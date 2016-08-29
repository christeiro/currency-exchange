class DailyRate < ApplicationRecord
  validates_presence_of :rate, :rate_date
  belongs_to :base_currency, class_name: "Currency", foreign_key: 'base_currency_id'
  belongs_to :target_currency, class_name: "Currency", foreign_key: 'target_currency_id'

  def self.daily_rate_exists?(base_currency_id)
    return true if self.where('base_currency_id = ? AND rate_date = ?', base_currency_id, Date.today).count(:id) > 0
    false
  end
end