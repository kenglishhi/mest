class Jobs::QueuedJobsController < Jobs::BaseController 

  active_scaffold :jobs do |config|
    config.list.label = 'Queued Jobs'
    config.update.label = 'Queued Jobs'
    config.create.link.label = 'Schedule'
    config.actions.exclude :nested
    config.create.columns = [:job_name, :priority, :run_at]
    config.update.columns = [:priority, :run_at]
    config.list.columns = [
      :job_name, :run_at, :priority, :attempts,
      :last_error, :failed_at, :created_at
    ]

  end

  protected

  def conditions_for_collection
    'locked_at is null'
  end

end
