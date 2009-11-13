require 'test_helper'

class Tools::BlastGroupNtAppendsControllerTest < ActionController::TestCase
  context "test blast group nt append controller" do
    setup do
      u = users(:users_001)
      UserSession.create(u)
      @delayed_job_count =  Job.count
    end

    should "Assert Should fail on post to empty params new with HTML " do
      get :create
      assert_response :success
    end

    should "Assert Should succeed on post to create with HTML" do
      post :create, :biodatabase_group_id =>  biodatabase_groups(:biodatabase_groups_001).id
      assert_response :redirect
      assert_equal @delayed_job_count + 1,Job.count
    end

    should "Assert Should succeed on post to create with JSON" do
      post :create, :format=> 'json',
        :biodatabase_group_id =>  biodatabase_groups(:biodatabase_groups_001).id
      assert_response :success
      assert_match /Data Saved/, @response.body
      assert_equal @delayed_job_count+1,Job.count
    end
  end


end
