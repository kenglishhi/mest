require File.dirname(__FILE__) + '/../test_helper'

class JobTest < ActiveSupport::TestCase
  should_belong_to :user
  context "Should Create UserJobNotification after creating JobLog" do
    setup do
      # Build a post object
      @old_count = UserJobNotification.count
      user = users(:users_001)
      @job_log = Factory(:job_log, :started_at => Time.now-300, :stopped_at=>Time.now,
        :user => user, :success => true )
    end

    should "increase by one" do
      assert @job_log.valid?
      assert_equal @old_count+1,UserJobNotification.count, "UserJobNotification.count  shoud increase by one"
    end
  end

end
