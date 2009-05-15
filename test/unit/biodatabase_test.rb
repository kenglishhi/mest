require File.dirname(__FILE__) + '/../test_helper'


class BiodatabaseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_have_many :biosequences
  should_belong_to :biodatabase_type
  should_validate_presence_of :name

end
