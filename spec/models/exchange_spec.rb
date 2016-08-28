require 'rails_helper'

describe Exchange do
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:period) }
  it { should validate_presence_of(:request_date) }
end