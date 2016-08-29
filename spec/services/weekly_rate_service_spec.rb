require 'rails_helper'

describe WeeklyRateService do
  it "creates the rates for the given period" do
    VCR.use_cassette "weekly_rate_response" do
      currency = Fabricate(:currency)
      usd = Money::Currency.new('USD')
      target_currency = Currency.create(code: usd.iso_code, name: usd.name )
      WeeklyRateService.new(currency.id, Date.today, 1).perform
      expect(WeeklyRate.count).to eq(1)
    end
  end
end