class BackgroundJobService
  def initialize(job)
    @job = job
  end

  def perform
    weekly_rates = WeeklyRateService.new(@job.base_currency_id, @job.start_date, @job.period).perform
    daily_rates = DailyRateService.new(@job.base_currency_id).perform
    raise Exception.new unless weekly_rates && daily_rates
    true
  end
end
