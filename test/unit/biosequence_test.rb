require File.dirname(__FILE__) + '/../test_helper'

class BiosequenceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_validate_presence_of :name, :seq, :alphabet
  should_validate_uniqueness_of :name
  should_have_many :biodatabases, :biodatabase_biosequences
  def test_to_s_and_to_fasta
     bioseq = biosequences( :biosequences_006)
     assert_not_nil bioseq.to_s
     assert_not_nil bioseq.to_fasta
  end
end
