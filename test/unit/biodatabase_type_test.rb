require File.dirname(__FILE__) + '/../test_helper'


class BiodatabaseTypeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_have_many :biodatabases
  should_validate_presence_of :name
end
