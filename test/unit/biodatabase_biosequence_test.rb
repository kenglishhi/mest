require File.dirname(__FILE__) + '/../test_helper'


class BiodatabaseBiosequenceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :biosequence
  should_belong_to :biodatabase

end
