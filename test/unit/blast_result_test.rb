require File.dirname(__FILE__) + '/../test_helper'

class BlastResultTest < ActiveSupport::TestCase
  should_have_attached_file :output
end
