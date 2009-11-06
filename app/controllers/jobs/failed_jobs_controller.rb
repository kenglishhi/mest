class Jobs::FailedJobsController < Jobs::BaseController 
  active_scaffold :jobs do |config|
    config.list.label = 'Failed Jobs'
    config.actions.exclude :nested, :create, :update
    config.list.columns = [
      :job_name, :run_at, :priority, :attempts,
      :last_error, :run_at, :failed_at
    ]
    config.list.sorting = [{:failed_at => :desc}]
  end

  protected

  def conditions_for_collection
    'failed_at is not null'
  end

end
