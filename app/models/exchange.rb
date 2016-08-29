require 'linear_regression'
class Exchange < ApplicationRecord
  validates_presence_of :amount, :period, :request_date
  validates :period, numericality: {only_integer: true, greater_than_or_equal_to: 1 }
  belongs_to :user
  belongs_to :base_currency, class_name: "Currency", foreign_key: 'base_currency_id'
  belongs_to :target_currency, class_name: "Currency", foreign_key: 'target_currency_id'
  has_many :background_jobs
end
