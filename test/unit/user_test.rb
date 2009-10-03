require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_attached_file :avatar
  should_have_many :fasta_files, :jobs, :job_logs
  def test_conveince_methods
    user = users(:users_001)
    assert_not_nil user.full_name, "Full name shouldn't be nil"
    assert_equal user.email, user.label, "Label should equal e-mail"
  end
end
