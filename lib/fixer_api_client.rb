class FixerApiClient
  include HTTParty

  base_uri 'http://api.fixer.io/'

  def initialize(date, options)
    @date = date
    @options = options
    @conn = Faraday.new(:url => 'http://api.fixer.io') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def perform
    begin
      binding.pry
      @conn.get "/#{@date}", @options
    rescue StandardError
      nil
    end
  end
end