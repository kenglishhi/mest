require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # Replace this with your real tests.

  context "test user controller" do
    setup do
      activate_authlogic
      @user = UserSession.create(users(:users_001))
    end

    context "Test the edit screen" do
      setup do
        user = users(:users_001)
        get :edit, :id => user.id
      end
      should_respond_with :success
      should_not_set_the_flash
      should_render_template :edit
    end
    context "Test the update " do
      setup do
        user = users(:users_001)
        put :update, :id => user.id, :user => {:first_name => 'kdog'}
      end
      should_respond_with :redirect
    end
    context "Test the update fails" do
      setup do
        user = users(:users_001)
        put :update, :id => user.id, :user => {:password => 'kdog',:password_confirmation => 'xdog'}
      end
      should_respond_with :success
      should_render_template :edit
    end

  end
end
