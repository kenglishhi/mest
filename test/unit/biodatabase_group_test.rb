require File.dirname(__FILE__) + '/../test_helper'

class BiodatabaseGroupTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :user
  should_validate_presence_of :name
end
