require 'rails_helper'

describe Currency do
  it { should validate_uniqueness_of(:code) }
  it { should validate_presence_of(:code) }
end