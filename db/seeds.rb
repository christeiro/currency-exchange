supported_currencies = %i(
  AUD BGN BRL CAD CHF CNY
  CZK DKK EUR GBP HKD HRK HUF IDR ILS INR
  JPY KRW MXN MYR NOK NZD PHP PLN RON RUB
  SEK SGD THB TRY USD ZAR
).map(&:downcase)

supported_currencies.each do |cur|
  currency = Money::Currency.table[cur]
  Currency.create!(code: currency[:iso_code], name: currency[:name])
end
