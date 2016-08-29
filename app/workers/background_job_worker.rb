class BackgroundJobWorker
  include Sidekiq::Worker

  def perform(job)
    begin
      BackgroundJobService.new(job).perform
    rescue  Exception => error
      nil
    end
  end
end