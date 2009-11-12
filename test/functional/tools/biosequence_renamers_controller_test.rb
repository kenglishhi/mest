require File.dirname(__FILE__) + '/../../test_helper'

class Tools::BiosequenceRenamersControllerTest < ActionController::TestCase
  context "Create a renamer job" do
    setup do
      u = users(:users_001)
      UserSession.create(u)
      @delayed_job_count =  Job.count
    end
    context "get to new" do
      setup do
        get :new, :biodatabase_id =>  biodatabases(:biodatabases_001).id
      end

      should "success on get to 'new' with HTML" do
        assert_response :success
      end
    end
    context "post to create with HTML" do
      setup do
        post :create, :biodatabase_id =>  biodatabases(:biodatabases_001).id, :prefix => 'xxx'
      end
      should "succeed on post to create with HTML" do
        assert_response :redirect
        assert_equal @delayed_job_count+1,Job.count
      end
    end
    context 'post to create with JSON' do
      setup do 
        post :create, :format=> 'json',
          :biodatabase_id =>  biodatabases(:biodatabases_001).id, :prefix => 'xxx'
      end
      should "succeed on post to create with JSON" do
        assert_response :success
        assert_match /Data Saved/, @response.body
        assert_equal @delayed_job_count+1,Job.count
      end
    end
  end
end
