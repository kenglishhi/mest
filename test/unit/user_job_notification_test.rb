require File.dirname(__FILE__) + '/../test_helper'

class UserJobNotificationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :user,  :job_log

  context "Create new job log and pop UserJobNotification" do
    setup do
      # Build a post object
      @old_count = UserJobNotification.count
      @user = users(:users_001)
      @count = 3
      @count.times do | i|
        @job_log = Factory(:job_log, :started_at => (Time.now - 200*i),
          :stopped_at=> (Time.now - 100*i), :user => @user, :success => true )
      end
    end

    should "pop all job notifications" do
      assert @job_log.valid?
      assert_equal @old_count + @count,UserJobNotification.count, "UserJobNotification.count  shoud increase by one"
      notifications = UserJobNotification.pop_user_job_notifications(@user)
      assert_equal notifications.size ,@count, "Size of notifications should be #{@count}"
      assert_equal 0,UserJobNotification.pop_user_job_notifications(@user).size, "Size of notifications should now be zero"
    end
  end

end
