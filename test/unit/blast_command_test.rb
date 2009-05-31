require 'test_helper'

class BlastCommandTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_validate_presence_of :biodatabase_type_id, :biodatabase_name, :test_fasta_file_id, :evalue
  should_belong_to :test_fasta_file, :target_fasta_file,:biodatabase, :biodatabase_type
  test "the truth" do
    assert true
  end
end
