# DailyRateService class is responsible for adding new daily rates.
class DailyRateService < WeeklyRateService
  def initialize(base_currency_id, start_date = Date.today.strftime('%Y-%m-%d'))
    @base_currency_id = base_currency_id
    @start_date = start_date
  end

  def perform
    unless rate_exists?(@base_currency_id)
      base = base_currency
      symbols = generate_symbols
      daily_rates = load_rates(@start_date, base, symbols)
      return false unless import_rates(daily_rates)
    end
    true
  end

  private

  def rate_exists?(base_currency_id)
    DailyRate.daily_rate_exists?(base_currency_id, @start_date)
  end

  def save_rates(currency_rates)
    ActiveRecord::Base.transaction do
      currencies_list = Currency.all
      currency_rates['rates'].each do |code, rate|
        target_currency_id = find_currency_id(currencies_list, code)
        DailyRate.create!(rate: rate, rate_date: @start_date,
                          target_currency_id: target_currency_id,
                          base_currency_id: @base_currency_id)
      end
    end
  end
end
