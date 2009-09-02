class JobLogsController < ApplicationController

  active_scaffold :job_logs do |config|
    config.label = "Job Log"
    config.actions.exclude :nested, :create, :update, :delete
  end

end

