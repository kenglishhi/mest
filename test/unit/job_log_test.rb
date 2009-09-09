require File.dirname(__FILE__) + '/../test_helper'

class JobTest < ActiveSupport::TestCase
  should_belong_to :user
end
