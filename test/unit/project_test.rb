require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :user
  should_validate_presence_of :name


  should "test convenience methods" do
    workbench_project_options = Project.workbench_project_options
    assert_not_nil workbench_project_options, "Should return some options"
    assert !workbench_project_options.empty?, "Should not return empty options"
    project = projects(:projects_001)
    assert !project.authorized_for_destroy?
  end
  context "Create new project" do
    setup do
      user = users(:users_001)
      @project  = Project.create(:name => "#{user.first_name} #{user.last_name} Project X",
        :description => "This is the new project for #{user.first_name} #{user.last_name}",
        :user => user)
    end
    should "Create a default database" do
      assert_equal @project.biodatabases.size, 1, "Should have one database by default"
      assert_equal @project.biodatabases.first.biodatabase_type, BiodatabaseType.database_group, "Type should equal group"
    end
  end
  should "have workbench project options" do
    workbench_project_options = Project.workbench_project_options
    assert_not_nil workbench_project_options, "Should return some options"
    assert !workbench_project_options.empty?, "Should not return empty options"
    project = projects(:projects_001)
    assert !project.authorized_for_destroy?
  end

end
