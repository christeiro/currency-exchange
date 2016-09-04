# Currency class for supported currencies in the system.
class Currency < ApplicationRecord
  validates_presence_of :code
  validates_uniqueness_of :code
  has_many :base_currencies, class_name: 'Exchange',
                             foreign_key: 'base_currency_id'
  has_many :target_currencies, class_name: 'Exchange',
                               foreign_key: 'target_currency_id'
end
