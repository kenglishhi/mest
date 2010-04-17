require 'test_helper'

class UserJobNotificationsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context "test index" do
    setup do
      activate_authlogic
      @user = UserSession.create(users(:users_001))
      get :index, :format=> 'json'
    end
    should_respond_with_extjs_json
  end
end
