require 'test_helper'

class Workbench::JobLogsControllerTest < ActionController::TestCase
  context_with_user_logged do
    should "succeed on get index with JSON" do
      get :index, :format=> 'json'
      should_respond_with_extjs_json
    end
  end
end
