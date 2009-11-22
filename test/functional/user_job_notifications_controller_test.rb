
require 'test_helper'
require File.dirname(__FILE__) + '/workbench/abstract_controller_test.rb'

class UserJobNotificationsControllerTest < Workbench::AbstractControllerTest
  # Replace this with your real tests.
  context "test index" do
    setup do
      activate_authlogic
      @user = UserSession.create(users(:users_001))
    end
    should "succeed on get index with JSON" do
      get :index, :format=> 'json'
      should_return_restful_json
    end
  end
end
