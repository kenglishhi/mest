class Jobs::JobLogsController < Jobs::BaseController
  before_filter :job_sub_nav

  active_scaffold :job_logs do |config|
    config.label = "Job Log"
    config.action_links.add('delete_all',
                            :label => 'Clear Log',
                            :inline => false,
                            :action => 'delete_all',
                            :confirm => 'This will clear the job logs. Are you sure?',
                            :method => :post)

    config.list.sorting = [{:started_at => :desc}]
    config.actions.exclude :nested, :create, :update
  end
  def delete_all
    JobLog.delete_all
    redirect_to :action => :index
  end


end

