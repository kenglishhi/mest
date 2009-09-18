require 'test_helper'

class BiodatabaseGroupTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :user
  should_validate_presence_of :name
  should_have_many :biodatabases
  test "the truth" do
    assert true
  end
end
