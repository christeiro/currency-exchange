require 'rails_helper'

describe Currency do
  it { should validate_uniqueness_of(:code) }
  it { should validate_presence_of(:code) }
  it do
    should have_many(:base_currencies).with_foreign_key('base_currency_id')
  end
  it do
    should have_many(:target_currencies).with_foreign_key('target_currency_id')
  end
end
