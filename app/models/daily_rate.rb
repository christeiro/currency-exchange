# DailyRate model holds the daily currency rates.
class DailyRate < ApplicationRecord
  validates_presence_of :rate, :rate_date
  belongs_to :base_currency, class_name: 'Currency'
  belongs_to :target_currency, class_name: 'Currency'

  def self.daily_rate_exists?(base_currency_id, rate_date)
    return true if where('base_currency_id = ? AND rate_date = ?',
                         base_currency_id, rate_date).count(:id) > 0
    false
  end
end
