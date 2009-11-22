require File.dirname(__FILE__) + '/../../test_helper'

class Workbench::BiodatabasesControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  context "log user in" do
    setup do
      activate_authlogic
      @user = UserSession.create(users(:users_001))
    end

    context "Move Biodatabse to another database group" do
      setup do
        @biodatabase = biodatabases(:biodatabases_001)
        @new_biodatabase_group = BiodatabaseGroup.create(:name => "my New Biodatabase Group",
          :user_id => @biodatabase.biodatabase_group.user_id,
          :parent_id =>@biodatabase.biodatabase_group.id,
          :project_id =>@biodatabase.biodatabase_group.project_id
        )
        xhr :post, :move, :id => @biodatabase.id, :new_biodatabase_group_id => @new_biodatabase_group.id

      end

      should "Extract sequences job should run" do
        assert_response :success
        assert_not_nil @biodatabase.reload
        assert_equal  @new_biodatabase_group.id, @biodatabase.biodatabase_group.id,"Database group should be changed after posting to action 'move'"
        #      assert_not_nil @new_biodatabase_group
      end
    end
  end
  context "test index" do
    setup do
      activate_authlogic
      @user = UserSession.create(users(:users_001))
    end
    should "succeed on get index with JSON and biodatabase_id" do
      get :index, :format=> 'json'
      assert_response :success
      resp_json = JSON.parse(@response.body)

      assert resp_json['results'] > 0,"Result count should be greater than 0"
      assert_not_nil resp_json['data'], "Data should not be nil"
      assert resp_json['data'].is_a?(Array), "Data should not be an array object"
    end
  end
end
