require 'test_helper'
require File.dirname(__FILE__) + '/../as_controller_test_helper.rb'

class Jobs::JobLogsControllerTest < ActionController::TestCase
  include AsControllerTestHelper
  def setup
    activate_authlogic
    @user = users(:users_001)
    UserSession.create(@user)
  end
  context "Restulf actions " do
    setup do
      activate_authlogic
      @user = users(:users_001)
      UserSession.create(@user)

    end
    context "test delete_all" do
      setup do
         post :delete_all
      end
      should_respond_with :redirect
      should "delete all job log records" do
        assert_equal 0, JobLog.count, "no jobs should exist"
      end
    end

  end
end
