require 'linear_regression'
# Exchange class for user currency exchange model.
class Exchange < ApplicationRecord
  validates_presence_of :amount, :request_date
  validates_numericality_of :period, only_integer: true,
                                     greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 250
  belongs_to :user
  belongs_to :base_currency, class_name: 'Currency',
                             foreign_key: 'base_currency_id'
  belongs_to :target_currency, class_name: 'Currency',
                               foreign_key: 'target_currency_id'
  has_many :background_jobs
end
