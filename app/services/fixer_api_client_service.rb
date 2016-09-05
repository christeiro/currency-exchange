require 'fixer_api_client'
# FixerApiClientService class holds the fixer.io API logic
class FixerApiClientService
  def initialize(date: Date.today.strftime('%Y-%m-%d'),
                 base: 'EUR', symbols: '')
    @date = date
    @base = base
    @symbols = symbols
  end

  def perform
    currency_rates = FixerApiClient.new(@date, query_params).perform
    get_rates(currency_rates)
  end

  private

  def get_rates(response)
    return false unless response
    JSON.parse(response.body)
  end

  def query_params
    return { base: @base }  if @symbols.empty?
    { base: @base, symbols: @symbols }
  end
end
