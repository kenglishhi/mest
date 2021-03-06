require 'test_helper'

class Workbench::JobsControllerTest < ActionController::TestCase

  context_with_user_logged do
    context "succeed on get index with JSON" do
      setup { get :index, :format=> 'json' }
      should_respond_with_extjs_json
    end
    context "succeed on get index with JSON with Queued" do
      setup { get :index, :format=> 'json',:option =>'Queued'}
      should_respond_with_extjs_json
    end
    context "succeed on get index with JSON with Failed" do
      setup { get :index, :format=> 'json',:option =>'Failed'}
      should_respond_with_extjs_json
    end
  end
end
