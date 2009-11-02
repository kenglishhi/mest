class Job < Delayed::Job
  include ExtJS::Model
  extjs_fields :id, :job_name, :run_at, :priority
  cattr_reader :per_page
  @@per_page = 25
  set_table_name 'delayed_jobs'
  belongs_to :user
  


  validates_presence_of :job_name
  validates_presence_of :user_id
                         
  before_create :add_user_to_job
  
  private
  
  def add_user_to_job
    self.handler.user_id = self.user.id
  end
end