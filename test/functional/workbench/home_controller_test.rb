require File.dirname(__FILE__) + '/../../test_helper'

class Workbench::HomeControllerTest < ActionController::TestCase
  # Replace this with your real tests.

  context_with_user_logged do
    should "Assert Should succeed on post to new with HTML" do
      get :index
      assert_response :success
    end
  end

end
