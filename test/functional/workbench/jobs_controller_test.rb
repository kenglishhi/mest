require 'test_helper'
require File.dirname(__FILE__) + '/abstract_controller_test.rb'

class Workbench::JobsControllerTest <Workbench::AbstractControllerTest

  context_with_user_logged do
    should "succeed on get index with JSON" do
      get :index, :format=> 'json'
      should_return_restful_json
    end
    should "succeed on get index with JSON with Queued" do
      get :index, :format=> 'json',:option =>'Queued'
      should_return_restful_json
    end
    should "succeed on get index with JSON with Failed" do
      get :index, :format=> 'json',:option =>'Failed'
      should_return_restful_json
    end
     context "Test destroy" do
      setup do
        @job = biodatabases(:biodatabases_001)
        @old_count = Biodatabase.count
        delete  'destroy', :format=> 'json', :id => @biodatabase.id
      end
      should "destroy record" do
        assert_response :success
        assert_equal  @old_count-1, Biodatabase.count
      end
    end
  end
end
