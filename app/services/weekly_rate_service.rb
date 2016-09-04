class WeeklyRateService
  def initialize(base_currency_id, start_date, period)
    @base_currency_id = base_currency_id
    @start_date = start_date.at_beginning_of_week
    @period = period
    @end_date = start_date.at_beginning_of_week - period.week
  end

  def perform
    missing_currency_rates = missing_rate_dates(existing_rate_dates)
    unless missing_currency_rates.empty?
      base = base_currency
      symbols = generate_symbols
      currency_rates = []
      missing_currency_rates.each do |date|
        rate = load_rates(date, base, symbols)
        currency_rates.push(rate) if rate
      end
      return false if currency_rates.empty?
      return import_rates(currency_rates)
    end
    true
  end

  private

  def existing_rate_dates
    WeeklyRate.rates_by_date(@base_currency_id, @start_date, @end_date)
  end

  def missing_rate_dates(existing_currency_rates = [])
    missing_currency_rates = []
    @period.times do
      missing_currency_rates.push(@start_date) unless existing_currency_rates.include?(@start_date)
      @start_date -= 1.week
    end
    missing_currency_rates
  end

  def load_rates(date, base, symbols)
    FixerApiClientService.new(date: date, base: base, symbols: symbols).perform
  end

  def import_rates(currency_rates)
    begin
      save_rates(currency_rates)
    rescue ActiveRecord::RecordInvalid
      return false
    end
    true
  end

  def save_rates(currency_rates)
    ActiveRecord::Base.transaction do
      currencies_list = Currency.all
      currency_rates.each do |rates|
        rate_date = rates["date"]
        rates["rates"].each do |code, rate|
          target_currency_id = find_currency_id(currencies_list, code)
          WeeklyRate.create!(rate: rate, rate_date: rate_date, target_currency_id: target_currency_id, base_currency_id: @base_currency_id)
        end
      end
    end
  end

  def base_currency
    currency = Currency.find(@base_currency_id)
    currency[:code]
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