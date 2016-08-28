class Exchange < ApplicationRecord
  validates_presence_of :amount, :period, :request_date
  belongs_to :user
  belongs_to :base_currency, class_name: "Currency", primary_key: 'base_currency_id'
  belongs_to :target_currency, class_name: "Currency", primary_key: 'target_currency_id'
end