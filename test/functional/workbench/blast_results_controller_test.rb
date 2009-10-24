require File.dirname(__FILE__) + '/../../test_helper'

class Workbench::BlastResultsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
 context "test index" do
    setup do
      activate_authlogic
      @user = UserSession.create(users(:users_001))
    end
    should "succeed on get index with JSON" do
      get :index, :format=> 'json'
      assert_response :success
      resp_json = JSON.parse(@response.body)
#      assert resp_json['results'] > 0, "Result count should be greater than 0"
      assert_not_nil resp_json['data'], "Data should not be nil"
      assert resp_json['data'].is_a?(Array), "Data should not be an array object"
    end
  end
end
