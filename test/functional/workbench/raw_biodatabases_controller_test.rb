require 'test_helper'

class Workbench::RawBiodatabasesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context_with_user_logged do
    should "succeed on get index with JSON" do
      get :index, :format=> 'json'
      should_respond_with_extjs_json
    end
  end
end
