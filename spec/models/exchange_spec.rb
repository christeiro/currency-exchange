require 'rails_helper'

describe Exchange do
  it { should validate_presence_of(:amount) }
  it do
    should validate_numericality_of(:period)
      .only_integer.is_less_than_or_equal_to(250)
      .is_greater_than_or_equal_to(1)
  end
  it { should validate_presence_of(:request_date) }
  it { should belong_to(:user) }
  it { should belong_to(:base_currency).with_foreign_key(:base_currency_id) }
  it do
    should belong_to(:target_currency).with_foreign_key(:target_currency_id)
  end
end
