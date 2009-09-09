require File.dirname(__FILE__) + '/../test_helper'

class JobTest < ActiveSupport::TestCase
  should_belong_to :user
  should_validate_presence_of :job_name, :user_id
end
