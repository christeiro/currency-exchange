require 'rails_helper'

describe WeeklyRateService do
  describe '#perform' do
    it 'creates the rates for the given period' do
      VCR.use_cassette 'weekly_rate_response' do
        currency = Fabricate(:currency)
        Currency.create(code: 'USD', name: 'US Dollar')
        WeeklyRateService.new(currency.id, Date.new(2016, 8, 29), 1).perform
        expect(WeeklyRate.count).to eq(1)
      end
    end
    it 'does not download rates if it exists' do
      currency = Fabricate(:currency)
      usd = Currency.create!(code: 'USD', name: 'USA Dollars')
      WeeklyRate.create(base_currency: currency, target_currency: usd,
                        rate: 1, rate_date: Date.new(2016, 8, 29))
      WeeklyRateService.new(currency.id, Date.new(2016, 8, 29), 1).perform
      expect(WeeklyRate.count).to eq(1)
    end
  end
end
