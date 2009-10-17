class JobLog < ActiveRecord::Base
  belongs_to :user
  after_create :create_user_job_notification
  def create_user_job_notification
    UserJobNotification.create!(:user_id => self.user_id, :job_log => self)
  end

end
