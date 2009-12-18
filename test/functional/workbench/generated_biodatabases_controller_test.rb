require 'test_helper'

class Workbench::GeneratedBiodatabasesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context_with_user_logged do
    should "succeed on get index with JSON" do
      get :index, :format=> 'json'
    end
  end
end
