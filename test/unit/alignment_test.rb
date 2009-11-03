require File.dirname(__FILE__) + '/../test_helper'

class AlignmentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :fasta_file

  context "Test alignment with ClustalW"  do
    setup do
      @test_fasta_file = fasta_files(:fasta_files_004)

      new Alignment.generate_alignment(@test_fasta_file,users(:users_001))
    end
    should "Generate a new alignment file" do
      assert File.exists?

    end
  end
end
