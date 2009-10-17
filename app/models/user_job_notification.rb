class UserJobNotification < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :id,:job_log_id,:user_id, :job_name

  belongs_to :user
  belongs_to :job_log
  named_scope :unnotified_jobs, lambda { |user|
      { :conditions => { :user_id => user.id, :notified => false } }
    }

  def self.pop_user_job_notifications(user)
    unnotified_jobs(user).each do | un|
      un.notified = true
      un.save
    end
  end
  def job_name
    self.job_log.job_name
  end
end
