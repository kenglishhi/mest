require 'pp'
class Jobs::AbstractJob

  DEBUG = false
  cattr_accessor :nt_database_directory
  attr_accessor :user_id
  attr_accessor :project_id
  attr_accessor :job_name
  attr_accessor :job_id
  attr_accessor :params
  def initialize(n, p  = {} )
    @job_name = n
    @params = p
    @user_id = p[:user_id] if p[:user_id]
    @project_id = p[:project_id] if p[:project_id]
  end
  def perform
    user_data = {:user_id => user_id, :project_id => project_id}
    params.merge!(user_data)

    logger.info "------------"  
    logger.info "Calling #{self.class}( params = #{params.inspect})  " 
    logger.info "------------" 

    update_estimated_completion_time if Job.exists?(job_id)

    do_perform

    logger.info "------------" 
    logger.info "FINISHED #{self.class}" 
    logger.info "--------------------------" 
  end
  # THESE Are used to trick out the exception notifier
  def controller_name
    self.class.to_s
  end
  def action_name
    self.class.to_s
  end
 
  include Jobs::Chainable
  include Jobs::Loggable

  protected
  
  def do_perform
    raise "subclasses must implement"
  end

  def update_job_estimated_completion_time
  end
 
end
