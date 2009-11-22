require 'test_helper'

class Workbench::TreesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context "test show" do
    setup do
      activate_authlogic
      @user = UserSession.create(users(:users_001))
    end
    should "succeed on get index with JSON" do
      get :show, :format=> 'json'
      assert_response :success
      resp_json = JSON.parse(@response.body)
      #      assert resp_json['results'] > 0, "Result count should be greater than 0"
      assert_not_nil resp_json, "Data should not be nil"
      assert resp_json.is_a?(Array), "Data should not be an array object"
    end
  end
end
