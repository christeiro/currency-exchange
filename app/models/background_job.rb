class BackgroundJob < ApplicationRecord
  validates_presence_of :start_date, :period
  belongs_to :base_currency, class_name: "Currency", foreign_key: 'base_currency_id'
  belongs_to :exchange
end