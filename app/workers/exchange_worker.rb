# ExchangeWorker is a class for background tasks.
# It uses sidekiq for running the tasks.
class ExchangeWorker
  include Sidekiq::Worker

  def perform(exchange_id)
    exchange = Exchange.find(exchange_id)
    WeeklyRateService.new(exchange.base_currency_id,
                          exchange.request_date, exchange.period).perform
    DailyRateService.new(exchange.base_currency_id).perform
    exchange.update_attributes!(completed: 1)
  end
end
