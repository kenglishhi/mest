require 'test_helper'
require File.dirname(__FILE__) + '/abstract_controller_test.rb'

class Workbench::JobsControllerTest <Workbench::AbstractControllerTest
  context "test index" do
    setup do
      activate_authlogic
      @user = UserSession.create(users(:users_001))
    end
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
  end
end
