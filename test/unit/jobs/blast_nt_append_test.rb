require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::BlastNtAppendTest < ActiveSupport::TestCase
  context "Blast db against NR" do
    setup do
      @fasta_file = fasta_files(:fasta_files_004)
      @biodatabase   = @fasta_file.extract_sequences
      @number_of_seqs = @biodatabase.biosequences.size
      assert File.exists?( @biodatabase.fasta_file.fasta.path ), "fasta_file should exist."
      @job =  Jobs::BlastNtAppend.new("Blasting #{@biodatabase.name} against NR",
        {:biodatabase_id => @biodatabase.id,
          :user_id => users(:users_001).id,
         :project_id => users(:users_001).active_project.id})
      @number_of_blast_results = BlastResult.count
    end

    should "Create add NR Sequences to DB" do
      @job.perform
      @biodatabase.reload
      assert_equal @number_of_blast_results + 1, BlastResult.count, "We should have a new biodatabase group"
      assert_equal @number_of_seqs+2, @biodatabase.biosequences.size
    end
  end
end

