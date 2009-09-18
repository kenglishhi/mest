require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::ExtractSequencesTest < ActiveSupport::TestCase
  context "Extract sequences from a Fasta File" do
    setup do
      filename =  "Plate-1_5_Trimmed_Sequences.fasta"
      tempfile = File.open(File.dirname(__FILE__) + "/../../fixtures/files/#{filename}")

      @fasta_file = FastaFile.new
      @fasta_file.fasta = tempfile
      @fasta_file.project = projects(:projects_001)
      assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
      assert File.exists?( @fasta_file.fasta.path ), "File should exist after create"
      @job =  Jobs::ExtractSequences.new("Extract #{@fasta_file.label}",
        {:fasta_file_id => @fasta_file.id })
    end

    should "Extract sequences job should run" do
     assert_not_nil @job.do_perform
     assert FastaFile.find(@job.params[:fasta_file_id] ).biodatabase.biosequences.size > 0
     assert_not_nil Biodatabase.last.fasta_file
    end
  end
end
