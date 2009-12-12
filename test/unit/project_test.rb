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
    should "Create a default database group" do
      assert_equal @project.biodatabase_groups.size, 1, "Should have one database group by default"
    end
  end
  should "create a default database group" do
    workbench_project_options = Project.workbench_project_options
    assert_not_nil workbench_project_options, "Should return some options"
    assert !workbench_project_options.empty?, "Should not return empty options"
    project = projects(:projects_001)
    assert !project.authorized_for_destroy?
  end

end
