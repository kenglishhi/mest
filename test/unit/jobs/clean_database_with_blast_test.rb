require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::CleanDatabaseWithBlastTest < ActiveSupport::TestCase
  should "require params" do
    job =  Jobs::CleanDatabaseWithBlast.new("Extract Database FAIL", { })
    assert_raise RuntimeError  do
      job.do_perform
    end
  end
  context "Clean a Database File" do
    setup do
      filename =  "Plate-1_5_Trimmed_Sequences.fasta"
      tempfile = File.open(File.dirname(__FILE__) + "/../../fixtures/files/#{filename}")

      @fasta_file = FastaFile.new
      @fasta_file.fasta = tempfile
      @fasta_file.project = projects(:projects_001)
      assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
      assert File.exists?( @fasta_file.fasta.path ), "File should exist after create"
      @fasta_file.extract_sequences

      assert !@fasta_file.biodatabase.biosequences.empty?

      @job =  Jobs::CleanDatabaseWithBlast.new("Clean Database #{@fasta_file.biodatabase.name}",
        {:biodatabase_id => @fasta_file.biodatabase.id,  :user_id => users(:users_001).id  })
      @number_of_blast_results = BlastResult.count

    end

    should "Clean Db job should run" do
     assert_not_nil @job.do_perform
     assert_equal @number_of_blast_results + 1, BlastResult.count, "We should have a new biodatabase group"
     assert_not_nil Biodatabase.last.fasta_file, "Clean should generate new fasta file"
    end
  end
end
