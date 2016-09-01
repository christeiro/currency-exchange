require 'rails_helper'

describe FixerApiClientService do
  it 'returns a list of currencies from fixer.io' do
    VCR.use_cassette "api_response_success" do
      date = Time.new(2016, 9, 1).strftime('%Y-%m-%d')
      supported_currencies = 'USD,NOK,SEK'
      response = FixerApiClientService.new(date: date, symbols: supported_currencies).perform
      expect(response).to be_an_instance_of(Hash)
    end
  end
end