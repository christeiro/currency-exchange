require 'rails_helper'

describe DailyRate do
  it { should validate_presence_of(:rate) }
  it { should validate_presence_of(:rate_date) }
  it { should belong_to(:base_currency) }
  it { should belong_to(:target_currency) }

  describe "daily_rate" do
    it "returns false if there's no records" do
      expect(DailyRate.daily_rate_exists?(1)).to be_falsey
    end

    it "returns true if the daily rate exists for given currency" do
      base_currency = Fabricate(:currency)
      usd = Money::Currency.new('USD')
      target_currency = Currency.create(code: usd.iso_code, name: usd.name )
      DailyRate.create!(rate: 1, rate_date: Date.today, base_currency: base_currency, target_currency_id: target_currency.id)
      expect(DailyRate.daily_rate_exists?(base_currency.id)).to be_truthy
    end
  end
end
