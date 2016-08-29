class WeeklyRate < ApplicationRecord
  validates_presence_of :rate_date, :rate
  belongs_to :base_currency, class_name: "Currency", foreign_key: 'base_currency_id'
  belongs_to :target_currency, class_name: "Currency", foreign_key: 'target_currency_id'

  def self.rates_by_date(base_currency_id, start_date, end_date)
    self.where('base_currency_id = ? AND rate_date <= ? AND rate_date >= ?', base_currency_id, start_date, end_date).distinct.pluck(:rate_date)
  end
end