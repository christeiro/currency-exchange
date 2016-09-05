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
    start_date = @exchange.request_date.at_beginning_of_week
    start_date -= @exchange.period.week
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
    LinearRegression.new(previous_weekly_rates)
  end

  def daily_rate
    currency_rate = DailyRate.select('rate')
                             .where('base_currency_id = ? AND
                                     target_currency_id = ? AND rate_date = ?',
                                    @exchange.base_currency_id,
                                    @exchange.target_currency_id,
                                    @exchange.request_date)
    currency_rate.first.rate
  end

  def calculate_future_rates
    current_value = @exchange.amount * daily_rate
    request_date = @exchange.request_date
    period = @exchange.period
    future_currency_rates_hsh(current_value, request_date, period)
  end

  def future_currency_rates_hsh(current_value, request_date, period)
    prediction = LinearRegression.new(previous_weekly_rates)
    @exchange.period.times do
      request_date += 1.week
      period += 1
      future_currency_rates.push(
        period: request_date.strftime('%Y W%W').to_s,
        predicted_rate: prediction.predict(period).round(4),
        future_value:  (@exchange.amount * future_rate).round(4),
        profit_loss: (future_value - current_value), rank: ''
      )
    end
  end
end
