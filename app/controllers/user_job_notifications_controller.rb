class UserJobNotificationsController < ApplicationController
  include ExtJS::Controller
  def index
    data = UserJobNotification.pop_user_job_notifications(current_user)
    results = data.size
    render :json => {:results => results, :data => data.map{|row|row.to_record}}
  end
end
