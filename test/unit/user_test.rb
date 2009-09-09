require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_attached_file :avatar
  should_have_many :fasta_files, :jobs, :job_logs
end
