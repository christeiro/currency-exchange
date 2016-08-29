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
      JSON.generate({"error": "Issues connecting with the site!"})
    end
  end
end