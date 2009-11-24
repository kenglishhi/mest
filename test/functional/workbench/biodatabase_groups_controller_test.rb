require File.dirname(__FILE__) + '/../../test_helper'

class Workbench::BiodatabaseGroupsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context_with_user_logged do
    should "succeed on get index with JSON and biodatabase_id" do
      get :index, :format=> 'json'
      assert_response :success
      resp_json = JSON.parse(@response.body)
      assert resp_json['results'] > 0,"Result count should be greater than 0"
      assert_not_nil resp_json['data'], "Data should not be nil"
      assert resp_json['data'].is_a?(Array), "Data should not be an array object"
    end

    context "test update" do
      setup do 
        @biodatabase_group = biodatabase_groups(:biodatabase_groups_001)
        @new_name = "New Bio Db Group Name"
        put :update, :format=> 'json',
          :id => @biodatabase_group, :data => {:name => @new_name}
      end
      should "update record" do
        assert_response :success
        @biodatabase_group.reload
        assert_equal @biodatabase_group.name, @new_name
      end
    end
    context "test create" do
      setup do
        @biodatabase_group = biodatabase_groups(:biodatabase_groups_001)
        @new_name = "New Bio Db Group Name"
        @old_count = BiodatabaseGroup.count
        post 'create', :format=> 'json',
          :parent_id => @biodatabase_group.id,
          :name => @new_name,
          :user_id => users(:users_001).id,
          :project_id => users(:users_001).active_project.id
        
      end
      should "create record" do
        assert_response :success
#        @biodatabase_group.reload
#        assert_equal @biodatabase_group.name, @new_name
        assert_equal  @old_count+1, BiodatabaseGroup.count
        assert_equal BiodatabaseGroup.last.name, @new_name
      end
    end
    context "Test move" do
      setup do
        @biodatabase_group = biodatabase_groups(:biodatabase_groups_002)
        @biodatabase_group_parent = biodatabase_groups(:biodatabase_groups_001)
        post 'move', :format=> 'json',
          :id => @biodatabase_group.id,
          :new_parent_id => @biodatabase_group_parent.id
      end
      should "move record" do
        assert_response :success
        @biodatabase_group.reload
        @biodatabase_group_parent.reload
        assert_equal @biodatabase_group.parent_id, @biodatabase_group_parent.id
      end
    end
    context "Test destroy" do
      setup do
        @biodatabase_group = biodatabase_groups(:biodatabase_groups_004)
        @old_count = BiodatabaseGroup.count
        delete  'destroy', :format=> 'json', :id => @biodatabase_group.id
      end
      should "destroy record" do
        assert_response :success
        assert_equal  @old_count-1, BiodatabaseGroup.count
      end
    end
  end
end
