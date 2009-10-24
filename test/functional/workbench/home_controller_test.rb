require File.dirname(__FILE__) + '/../../test_helper'

class Workbench::HomeControllerTest < ActionController::TestCase
  # Replace this with your real tests.

  context "test workbench index" do
    setup do
      activate_authlogic
      @user = UserSession.create(users(:users_001))
    end
    should "Assert Should succeed on post to new with HTML" do
      get :index
      assert_response :success
    end
  end

end
