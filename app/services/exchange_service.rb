# ExchangeService class does two things
# 1. It checks if the Sidekiq worker has finished downloading rates
# 2. It returns the predicted currency rates, if nr. 1. is completed
class ExchangeService
  def initialize(exchange)
    @exchange = exchange
  end

  def perform
    return false if @exchange.completed.zero?
    future_rates
  end

  def future_rates
    rates = calculate_future_rates
    sorted_rates = rates.sort_by { |x| x[:predicted_rate] }
    sorted_rates.reverse.first(3).each_with_index do |rate, i|
      rate[:rank] = i + 1
    end
    rates
  end

  def previous_weekly_rates
    start_date = @exchange.request_date.at_beginning_of_week -
                 @exchange.period.week
    weekly_rates = WeeklyRate.select(:rate)
                             .where('base_currency_id = ?
                                     AND target_currency_id = ?
                                     AND rate_date >= ? AND rate_date <= ?',
                                    @exchange.base_currency_id,
                                    @exchange.target_currency_id,
                                    start_date, @exchange.request_date)
    weekly_rates.map(&:rate)
  end

  def prediction
    @prediction ||= LinearRegression.new(previous_weekly_rates)
  end

  def daily_rate
    currency_rate = DailyRate.select('rate')
                             .where('base_currency_id = ?
                                     AND target_currency_id = ?
                                     AND rate_date = ?',
                                    @exchange.base_currency_id,
                                    @exchange.target_currency_id,
                                    @exchange.request_date)
    currency_rate.first.rate
  end

  def calculate_future_rates
    future_currency_rates_hsh
  end

  def future_currency_rates_hsh
    future_currency_rates = []
    @exchange.period.times do |interval|
      future_currency_rates
        .push(period: future_date(interval),
              predicted_rate: future_rate(prediction, interval),
              future_value: future_value(prediction, interval),
              profit_loss: profit_loss(prediction, interval),
              rank: '')
    end
    future_currency_rates
  end

  def current_value
    current_rate_value = @exchange.amount * daily_rate
    current_rate_value
  end

  def future_date(interval)
    sequence = interval + 1
    future_date_value = @exchange.request_date + sequence.week
    future_date_value.strftime('%Y W%W').to_s
  end

  def future_period(interval)
    sequence = interval + 1
    future_period_value = @exchange.period + sequence
    future_period_value
  end

  def future_rate(prediction, interval)
    future_rate_value = prediction.predict(future_period(interval))
    future_rate_value.round(4)
  end

  def future_value(prediction, interval)
    future_exchange_value = future_rate(prediction, interval) * @exchange.amount
    future_exchange_value.round(2)
  end

  def profit_loss(prediction, interval)
    profit_loss_value = future_value(prediction, interval) - current_value
    profit_loss_value.round(2)
  end
end
