require File.dirname(__FILE__) + '/../../test_helper'

class Workbench::BiosequencesControllerTest < ActionController::TestCase
  # Replace this with your real tests.

  context_with_user_logged do
    should "succeed on get index with JSON and biodatabase_id" do
      get :index, :format=> 'json',
        :biodatabase_id =>  biodatabases(:biodatabases_001).id
      assert_response :success
      resp_json = JSON.parse(@response.body)
      assert resp_json['results'] > 0,"Result count should be greater than 0"
      assert_not_nil resp_json['data'], "Data should not be nil"
      assert resp_json['data'].is_a?(Array), "Data should not be an array object"
    end
    should "succeed on get index with JSON" do
      get :index, :format=> 'json'
      assert_response :success
      resp_json = JSON.parse(@response.body)
      assert resp_json['results'] > 0,"Result count should be greater than 0"
      assert_not_nil resp_json['data'], "Data should not be nil"
      assert resp_json['data'].is_a?(Array), "Data should not be an array object"

    end
  end
end
