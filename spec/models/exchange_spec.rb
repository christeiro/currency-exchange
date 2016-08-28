require 'rails_helper'

describe Exchange do
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:period) }
  it { should validate_presence_of(:request_date) }
  it { should belong_to(:user) }
  it { should belong_to(:base_currency).with_primary_key(:base_currency_id) }
  it { should belong_to(:target_currency).with_primary_key(:target_currency_id) }
end