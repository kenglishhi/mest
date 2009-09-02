class Job < Delayed::Job
  set_table_name 'delayed_jobs'
  
  validates_presence_of :job_name
                         
#  before_create :add_job
  
  private
  
#  def add_job
#    self.handler = job_name.constantize.new
#  end
end