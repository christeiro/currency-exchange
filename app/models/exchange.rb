class Exchange < ApplicationRecord
  validates_presence_of :amount, :period, :request_date
end