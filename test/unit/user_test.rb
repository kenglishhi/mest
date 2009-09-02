require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_many :fasta_files, :jobs, :job_logs
  # Replace this with your real tests.
end
