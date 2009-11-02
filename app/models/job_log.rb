class JobLog < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :id, :job_name , :job_class_name, :started_at, :stopped_at,
    :duration_in_seconds, :success , :user_id
  cattr_reader :per_page
  @@per_page = 25

  belongs_to :user
  after_create :create_user_job_notification
  def create_user_job_notification
    UserJobNotification.create!(:user_id => self.user_id, :job_log => self)
  end

end
