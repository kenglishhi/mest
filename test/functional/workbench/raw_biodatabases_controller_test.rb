require 'test_helper'

class Workbench::RawBiodatabasesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context_with_user_logged do
    setup do
      get :index, :format=> 'json'
    end
    should_respond_with_extjs_json
  end

end
