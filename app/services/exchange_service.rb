class ExchangeService
  def initialize(exchange)
    @exchange = exchange
  end

  def perform
    job = @exchange.background_jobs.last
    return false unless job.completed
    future_rates
  end

  def future_rates
    rates = calculate_future_rates
    rates.sort_by { |x| x[:predicted_rate] }.reverse.first(3).each_with_index do |rate, i |
      rate[:rank] = i + 1
    end
    rates
  end

  def previous_weekly_rates
    start_date = @exchange.request_date.at_beginning_of_week - @exchange.period.week
    weekly_rates = WeeklyRate.select(:rate).where('base_currency_id = ? AND target_currency_id = ? AND rate_date >= ? AND rate_date <= ?', @exchange.base_currency_id, @exchange.target_currency_id, start_date, @exchange.request_date )
    weekly_rates.map(&:rate)
  end

  def prediction
    LinearRegression.new(previous_weekly_rates)
  end

  def daily_rate
    currency_rate = DailyRate.select('rate').where('base_currency_id = ? AND target_currency_id = ? AND rate_date = ?', @exchange.base_currency_id, @exchange.target_currency_id, Date.today)
    currency_rate.first.rate
  end


  def calculate_future_rates
    prediction = LinearRegression.new(previous_weekly_rates)
    # binding.pry
    future_currency_rates = []
    current_value = @exchange.amount * daily_rate
    @exchange.period.times do
      @exchange.request_date += 1.week
      @exchange.period += 1
      future_rate = prediction.predict(@exchange.period)
      future_value = @exchange.amount * future_rate
      profit_loss = future_value - current_value
      future_currency_rates.push({
                                   'period': "#{@exchange.request_date.strftime('%Y W%W')}",
                                   'predicted_rate': future_rate.round(4),
                                   'future_value': future_value.round(2),
                                   'profit_loss': profit_loss.round(4),
                                   'rank': ''
                                 })
    end
    future_currency_rates
  end
end