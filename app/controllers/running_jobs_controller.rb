class RunningJobsController < ApplicationController

  active_scaffold :jobs do |config|
    config.actions.exclude :nested, :create, :update
    config.label = 'Running Jobs'
    config.list.label = 'Running Jobs'
    config.list.columns = [
      :job_name, :run_at, :priority, :attempts,
      :last_error, :run_at, :locked_at, :failed_at,
      :locked_by
    ]
  end

  protected

  def conditions_for_collection
    'locked_at is not null'
  end

end