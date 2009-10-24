require File.dirname(__FILE__) + '/../test_helper'

class BiodatabaseGroupTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :user
  should_validate_presence_of :name
  should_have_many :biodatabases
  should "test ext_tree method" do
    assert_not_nil BiodatabaseGroup.first.ext_tree
    assert BiodatabaseGroup.first.ext_tree.is_a? Hash
  end
end
