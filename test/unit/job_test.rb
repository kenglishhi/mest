require File.dirname(__FILE__) + '/../test_helper'

class JobTest < ActiveSupport::TestCase
  should_belong_to :user
  should_validate_presence_of :job_name, :user_id


  should "Create a new job side effects" do
    current_user = users(:users_001)
    params = {}
    delayed_job_count =  Job.count
    job_name = "Say Hello to my little friend"
    job_handler = Jobs::CleanDatabaseWithBlast.new(job_name, params.merge(:user_id => current_user.id))
    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => current_user )

    assert_equal delayed_job_count + 1,Job.count
  end
end
