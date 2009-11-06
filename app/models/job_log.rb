class JobLog < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :id, :job_name , :job_class_name, :user_id , :duration_display,
  :success,:user_email, :stopped_at
 #, :stopped_at
#    :duration_in_seconds, :success , :user_id
  cattr_reader :per_page
  @@per_page = 25

  belongs_to :user
  belongs_to :project

  validates_presence_of :user_id
  validates_presence_of :project_id

  after_create :create_user_job_notification
  def create_user_job_notification
    UserJobNotification.create!(:user_id => self.user_id, :job_log => self)
  end
  def duration_display
    duration = duration_in_seconds.to_i
    [ duration / 3600,  (duration / 60) % 60, duration % 60 ].map{ |t| t.to_s.rjust(2, '0') }.join(':')
  end
  def user_email
    user.email
  end

end
