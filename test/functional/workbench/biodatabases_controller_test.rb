require File.dirname(__FILE__) + '/../../test_helper'

class Workbench::BiodatabasesControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  context_with_user_logged do
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

  context "test restful actions" do
    setup do
      activate_authlogic
      @user = users(:users_001)
      UserSession.create(@user)
    end
    context "test update" do
      setup do 
        @biodatabase = biodatabases(:biodatabases_001)
        @new_name = "New Db Name"
        put :update, :format=> 'json',
          :id => @biodatabase, :data => {:name => @new_name}
      end
      should "update record" do
        assert_response :success
        @biodatabase.reload
        assert_equal @biodatabase.name, @new_name
      end
    end
    context "test index" do
      setup do
        get :index, :format=> 'json'
      end
      should_respond_with :success
      should "succeed on get index with JSON and biodatabase_id" do
        resp_json = JSON.parse(@response.body)

        assert resp_json['results'] > 0,"Result count should be greater than 0"
        assert_not_nil resp_json['data'], "Data should not be nil"
        assert resp_json['data'].is_a?(Array), "Data should not be an array object"
      end
    end
    context "test index with biodatabase group_id" do
      setup do
        get :index, :format=> 'json', :biodatabase_group_id => biodatabase_groups(:biodatabase_groups_001).id
      end
      should_respond_with :success
      should "succeed on get index with JSON and biodatabase_id" do
        resp_json = JSON.parse(@response.body)
        assert resp_json['results'] > 0,"Result count should be greater than 0"
        assert_not_nil resp_json['data'], "Data should not be nil"
        assert resp_json['data'].is_a?(Array), "Data should not be an array object"
      end
    end
    context "test show" do
      setup do
        get :show, :format=> 'json', :id => biodatabases(:biodatabases_001).id
      end
      should_respond_with :success
    end

    context "Test destroy" do
      setup do
        @biodatabase = biodatabases(:biodatabases_001)
        @old_count = Biodatabase.count
        delete  'destroy', :format=> 'json', :id => @biodatabase.id
      end
      should "destroy record" do
        assert_response :success
        assert_equal  @old_count-1, Biodatabase.count
      end
    end
  end
end
