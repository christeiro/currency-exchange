require 'rails_helper'

describe BackgroundJob do
  it { should belong_to(:base_currency).with_foreign_key(:base_currency_id) }
  it { should belong_to(:target_currency).with_foreign_key(:target_currency_id) }
  it { should belong_to(:exchange) }
end
