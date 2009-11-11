class JobLog < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :id, :job_name , :job_class_name, :user_id , :duration_display,
    :success,:user_email, :stopped_at
  cattr_reader :per_page
  @@per_page = 25

  belongs_to :user
  belongs_to :project

  after_create :create_user_job_notification

  def create_user_job_notification
    if self.user_id
      UserJobNotification.create!(:user_id => self.user_id, :job_log => self)
    end
  end
  def duration_display
    duration = duration_in_seconds.to_i
    [ duration / 3600,  (duration / 60) % 60, duration % 60 ].map{ |t| t.to_s.rjust(2, '0') }.join(':')
  end
  def user_email
    user.email
  end

end
