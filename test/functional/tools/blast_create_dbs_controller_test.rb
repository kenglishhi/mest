require File.dirname(__FILE__) + '/../../test_helper'

class Tools::BlastCreateDbsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context "test blast create dbs " do
    setup do
      u = users(:users_001)
      UserSession.create(u)
      @delayed_job_count =  Job.count
    end
    should "Assert Should succeed on post to new with HTML" do
      get :new, :test_biodatabase_id =>  biodatabases(:biodatabases_001).id
      assert_response :success
    end

    should "Assert Should succeed on post to create with HTML" do
      assert true
      post :create, :test_biodatabase_id =>  biodatabases(:biodatabases_001).id,
        :target_biodatabase_id =>  biodatabases(:biodatabases_001).id,
        :prefix => 'xxx'
      assert_response :redirect
      assert_equal @delayed_job_count+1,Job.count
    end

    should "Assert Should succeed on post to create with JSON" do
      assert true
      post :create, :format=> 'json', :test_biodatabase_id =>  biodatabases(:biodatabases_001).id,
        :target_biodatabase_id =>  biodatabases(:biodatabases_001).id,
        :prefix => 'xxx'
      #:biodatabase_id =>  biodatabases(:biodatabases_001).id, :prefix => 'xxx'
      assert_response :success
      assert_match /Data Saved/, @response.body
      assert_equal @delayed_job_count+1,Job.count
    end
  end

end
