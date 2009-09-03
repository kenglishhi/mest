class JobLogsController < ApplicationController

  active_scaffold :job_logs do |config|
    config.label = "Job Log"
    config.list.sorting = [{:started_at => :desc}]
    config.actions.exclude :nested, :create, :update
  end

end

