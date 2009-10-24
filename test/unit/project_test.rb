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
end
