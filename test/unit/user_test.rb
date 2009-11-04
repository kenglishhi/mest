require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_attached_file :avatar
  should_have_many :fasta_files, :jobs, :job_logs, :projects
  should_belong_to :default_project
  def test_conveince_methods
    user = users(:users_001)
    assert_not_nil user.full_name, "Full name shouldn't be nil"
    assert_equal user.email, user.label, "Label should equal e-mail"
  end
  def test_after_create
    old_project_count = Project.count
    user = User.create(:first_name => 'kelvin', 
      :last_name => 'fenglish',
      :email => 'kelvinfen@yahoo.com',
      :password => 'kelvin',
      :password_confirmation => 'kelvin')

    assert user.valid?, user.errors.full_messages.to_sentence
    assert_equal old_project_count + 1, Project.count
    assert_equal Project.last.user_id,  user.id

  end
end
