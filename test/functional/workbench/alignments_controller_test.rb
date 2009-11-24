require 'test_helper'

class Workbench::AlignmentsControllerTest < ActionController::TestCase
  context_with_user_logged do
    context  "succeed on get index with JSON and biodatabase_id" do
      setup do
        get :index, :format=> 'json',
          :biodatabase_id =>  biodatabases(:biodatabases_001).id
      end
      should_respond_with_extjs_json
    end

    context "succeed on get index with JSON" do
      setup do
        get :index, :format=> 'json'
      end
      should_respond_with_extjs_json
    end
  end
end
