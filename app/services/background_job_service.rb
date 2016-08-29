class BackgroundJobService
  def initialize(job)
    @job = job
  end

  def perform
    WeeklyRateService.new({base_currency: @job.base_currency_id, start_date: @job.start_date, period: @job.period}).perform
  end
end
