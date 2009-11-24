require 'test_helper'
require File.dirname(__FILE__) + '/abstract_controller_test.rb'

class Workbench::JobLogsControllerTest < Workbench::AbstractControllerTest
  context_with_user_logged do
    should "succeed on get index with JSON" do
      get :index, :format=> 'json'
      should_return_restful_json
    end
  end
end
