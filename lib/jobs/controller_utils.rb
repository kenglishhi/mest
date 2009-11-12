module Jobs::ControllerUtils
  protected
  def create_job(job_class,job_name,user,params)
    job_handler = job_class.new(job_name,params)
    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => user,
      :project => user.active_project )

  end
end
