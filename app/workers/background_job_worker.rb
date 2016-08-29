class BackgroundJobWorker
  include Sidekiq::Worker

  def perform(job_id)
    job = BackgroundJob.find(job_id)
    BackgroundJobService.new(job).perform
    job.update_attributes!(completed: 1)
  end
end