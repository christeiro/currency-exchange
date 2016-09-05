require 'rails_helper'

describe DailyRateService do
  describe '#perform' do
    it 'creates a daily rate if it does not exist' do
      VCR.use_cassette 'daily_rate_response' do
        currency = Fabricate(:currency)
        Currency.create(code: 'USD', name: 'USD Dollars')
        DailyRateService.new(currency.id, Date.new(2016, 9, 4)).perform
        expect(DailyRate.count).to eq(1)
      end
    end
    it 'does not create the daily rate if it exists' do
      currency = Fabricate(:currency)
      usd = Currency.create(code: 'USD', name: 'USD Dollars')
      DailyRate.create!(base_currency: currency,
                        target_currency: usd,
                        rate_date: Date.new(2016, 9, 4),
                        rate: 1)
      DailyRateService.new(currency.id, Date.new(2016, 9, 4)).perform
      expect(DailyRate.count).to eq(1)
    end
  end
end
