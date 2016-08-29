class FixerApiClient
  include HTTParty

  base_uri 'http://api.fixer.io/'

  def initialize(date, options)
    @date = date
    @options = options
  end

  def perform
    begin
      self.class.get("/#{@date}", @options)
    rescue StandardError
      nil
    end
  end
end