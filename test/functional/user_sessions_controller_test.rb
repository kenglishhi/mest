require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  # Replace this with your real tests.

  context "on GET to :new for login " do
    setup do
      get :new
    end

    should_respond_with    :success
    should_render_template :new
    should_not_set_the_flash
  end

  context "on POST to :create for a login" do
    setup do
      @user = users(:users_001)
      post :create,"user_session"=> {:email => @user.email, :password => 'kevin123'}
    end

    should_respond_with    :redirect
    should_set_the_flash_to "Login successful!"
  end

  context "on POST to :create for a login FAIL" do
    setup do
      @user = users(:users_001)
      post :create,"user_session"=> {:email => @user.email, :password => 'xxxxxxxx'}
    end

    should_respond_with    :success
    should_render_template :new
    should_not_set_the_flash
  end


end
