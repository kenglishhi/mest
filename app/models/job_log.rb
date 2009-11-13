class JobLog < ActiveRecord::Base
  include ExtJS::Model
  include DurationDisplay
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
    duration_format(duration_in_seconds)
  end
  def user_email
    user.email
  end

end
