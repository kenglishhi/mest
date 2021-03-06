class Job < Delayed::Job
  include DurationDisplay
  include ExtJS::Model
  extjs_fields :id, :job_name, :run_at, :priority, :duration_display,
    :duration_remaining_display,:user_email
  cattr_reader :per_page
  @@per_page = 25
  set_table_name 'delayed_jobs'
  belongs_to :user
  belongs_to :project
  
  validates_presence_of :job_name
  validates_presence_of :user_id
  validates_presence_of :project_id
                         
  before_create :add_user_to_job
  after_create :add_job_id_to_job
  def duration_display
    if locked_at &&  failed_at
      duration_format(failed_at - locked_at)
    elsif locked_at
      duration_format(Time.now - locked_at)
    else
      duration_format(0)
    end
  end

  def duration_remaining_display
    return duration_format(0) unless self.estimated_completion_date

    seconds_remaining = self.estimated_completion_date  - Time.now
    if (locked_at && !failed_at) && seconds_remaining > 0
       duration_format(seconds_remaining )
     else
      duration_format(0)
    end
  end


  def user_email
    user.email
  end
  
  private
  
  def add_user_to_job
    self.handler.user_id = self.user.id || self.user_id
    self.handler.project_id = self.project.id || self.project_id
  end

  def add_job_id_to_job
    self.handler.job_id = self.id 
    self.save
  end

end