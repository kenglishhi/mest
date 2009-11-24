require 'test_helper'
require File.dirname(__FILE__) + '/as_controller_test_helper.rb'

class BiosequencesControllerTest < ActionController::TestCase
  include AsControllerTestHelper
  def setup
    activate_authlogic
    @user = UserSession.create(users(:users_001))
  end

  context "Test Show" do
    context_with_user_logged do 
      setup do

      get "show", :id => biosequences(:biosequences_001).id
      end
      should_respond_with    :success
    end
  end
end
