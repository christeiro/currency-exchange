class DailyRateService
  def initialize(base_currency_id)
    @base_currency_id = base_currency_id
    @start_date = Date.today.strftime('%Y-%m-%d')
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
    DailyRate.daily_rate_exists?(base_currency_id)
  end

  def load_rates(date, base, symbols)
    FixerApiClientService.new(base: base[:code], symbols: symbols).perform
  end

  def import_rates(currency_rates)
    begin
      save_rates(currency_rates)
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end

  def save_rates(currency_rates)
    ActiveRecord::Base.transaction do
      currencies_list = Currency.all
      currency_rates["rates"].each do |code, rate|
        target_currency_id = find_currency_id(currencies_list, code)
        DailyRate.create!(rate: rate, rate_date: Date.today, target_currency_id: target_currency_id, base_currency_id: @base_currency_id)
      end
    end
  end

  def base_currency
    Currency.find(@base_currency_id)
  end

  def find_currency_id(currencies_list, currency_code)
    currencies_list.each do |currency|
      return currency[:id] if currency[:code] == currency_code
    end
    nil
  end

  def generate_symbols
    currencies = Currency.select(:code).map(&:code)
    currencies*","
  end
end
