require 'rails_helper'

describe WeeklyRate do
  it { validate_presence_of(:rate_date) }
  it { validate_presence_of(:rate) }
  it { should belong_to(:base_currency) }
  it { should belong_to(:target_currency) }

  describe 'existing_rates_by_date' do
    it 'returns an empty array if there\'s no records' do
      expect(WeeklyRate.rates_by_date(1, Date.today, Date.today)).to eq([])
    end

    it 'returns the dates for the given currency' do
      base_currency = Fabricate(:currency)
      usd = Money::Currency.new('USD')
      target_currency = Currency.create(code: usd.iso_code, name: usd.name)
      weekly_rate = WeeklyRate.create(rate: 1,
                                      rate_date: Date.today,
                                      base_currency: base_currency,
                                      target_currency_id: target_currency.id)
      expect(
        WeeklyRate.rates_by_date(base_currency.id,
                                 weekly_rate.rate_date,
                                 weekly_rate.rate_date)
      ).to eq([weekly_rate.rate_date])
    end

    it 'returns the dates for the given period' do
      base_currency = Fabricate(:currency)
      usd = Money::Currency.new('USD')
      target_currency = Currency.create(code: usd.iso_code, name: usd.name)
      weekly_rate = WeeklyRate.create(rate: 1,
                                      rate_date: 1.week.ago,
                                      base_currency: base_currency,
                                      target_currency_id: target_currency.id)
      expect(
        WeeklyRate.rates_by_date(base_currency.id, Date.today, 2.week.ago)
      ).to eq([weekly_rate.rate_date])
    end

    it 'does not return the dates for other currencies' do
      base_currency = Fabricate(:currency)
      usd = Money::Currency.new('USD')
      target_currency = Currency.create(code: usd.iso_code, name: usd.name)
      eur_weekly_rate = WeeklyRate.create(
        rate: 1,
        rate_date: 1.day.ago,
        base_currency: base_currency,
        target_currency_id: target_currency.id
      )
      usd_weekly_rate = WeeklyRate.create(rate: 1,
                                          rate_date: 5.day.ago,
                                          base_currency: target_currency,
                                          target_currency_id: base_currency.id)
      expect(
        WeeklyRate.rates_by_date(eur_weekly_rate.id,
                                 eur_weekly_rate.rate_date,
                                 eur_weekly_rate.rate_date)
      ).not_to include(usd_weekly_rate.rate_date)
    end

    it 'does not return the dates from other period' do
      base_currency = Fabricate(:currency)
      usd = Money::Currency.new('USD')
      target_currency = Currency.create(code: usd.iso_code, name: usd.name)
      first_weekly_rate = WeeklyRate.create(
        rate: 1,
        rate_date: 5.week.ago,
        base_currency: base_currency,
        target_currency_id: target_currency.id
      )
      WeeklyRate.create(rate: 1,
                        rate_date: 3.week.ago,
                        base_currency: base_currency,
                        target_currency_id: target_currency.id)
      expect(
        WeeklyRate.rates_by_date(base_currency.id, 1.week.ago, 4.week.ago)
      ).not_to include([first_weekly_rate.rate_date])
    end
  end
end
