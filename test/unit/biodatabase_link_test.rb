require 'test_helper'

class BiodatabaseLinkTest < ActiveSupport::TestCase
  # Replace this with your real tests.

  should_belong_to :biodatabase
  should_belong_to :linked_biodatabase
  should_belong_to :biodatabase_link_type
end
