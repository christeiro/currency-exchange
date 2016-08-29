require 'rails_helper'

describe WeeklyRate do
  it { validate_presence_of(:rate_date) }
  it { validate_presence_of(:rate) }
  it { should belong_to(:base_currency).with_foreign_key(:base_currency_id) }
  it { should belong_to(:target_currency).with_foreign_key(:target_currency_id) }
end