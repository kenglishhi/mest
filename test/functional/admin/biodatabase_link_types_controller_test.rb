require 'test_helper'
require File.dirname(__FILE__) + '/../as_controller_test_helper.rb'

class Admin::BiodatabaseLinkTypesControllerTest < ActionController::TestCase
  include AsControllerTestHelper
  def setup
    activate_authlogic
    @user = UserSession.create(users(:users_001))
  end
end
