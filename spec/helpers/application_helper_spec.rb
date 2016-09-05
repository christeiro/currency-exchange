require 'rails_helper'

describe ApplicationHelper do
  describe 'alert_for' do
    it 'returns the class for given flash type' do
      expect(alert_for(:error)).to eq('alert-danger')
    end

    it 'returns the input value if there\'s no match' do
      expect(alert_for(:does_not_exist)).to eq('does_not_exist')
    end
  end
end
