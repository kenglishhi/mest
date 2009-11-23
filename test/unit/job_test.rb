require File.dirname(__FILE__) + '/../test_helper'

class JobTest < ActiveSupport::TestCase
  should_belong_to :user
  should_validate_presence_of :job_name, :user_id

  context "Create a new job side effects" do
    setup do
      current_user = users(:users_001)
      @delayed_job_count =  Job.count
      job_name = "Say Hello to my little friend"
      job_handler = Jobs::CleanDatabaseWithBlast.new(job_name )
      Job.create(:job_name => job_name,
        :handler => job_handler,
        :user => current_user,
        :project => current_user.active_project)


    end
    should "Increase count by one" do
      assert_equal @delayed_job_count + 1,Job.count
    end
    should "ALways have a duration display" do
      assert_not_nil Job.last.duration_display
      assert_match /\d\d:\d\d/, Job.last.duration_display, "Duration should have a 00:00 type format"
    end

  end
end
