class BackgroundJobService
  def initialize(job)
    @job = job
  end

  def perform

    raise Exception.new
  end

  private
end