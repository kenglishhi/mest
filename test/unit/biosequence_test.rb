require File.dirname(__FILE__) + '/../test_helper'

class BiosequenceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_validate_presence_of :name, :seq, :alphabet
  should_have_many :biodatabases, :biodatabase_biosequences

end
