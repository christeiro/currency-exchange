class WeeklyRate < ApplicationRecord
  validates_presence_of :rate_date, :rate
  belongs_to :base_currency, class_name: "Currency", foreign_key: 'base_currency_id'
  belongs_to :target_currency, class_name: "Currency", foreign_key: 'target_currency_id'
end