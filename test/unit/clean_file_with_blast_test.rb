require File.dirname(__FILE__) + '/../test_helper'
class CleanFileWithBlastTest < ActiveSupport::TestCase
  context "Clean A Fasta File" do
    setup do
      filename =  "EST_Clade_A_5.fasta"
      tempfile = File.open(File.dirname(__FILE__) + "/../fixtures/files/#{filename}")

      fasta_file = FastaFile.new
      fasta_file.fasta = tempfile
      fasta_file.project = projects(:projects_001)
      assert fasta_file.save, "Saving fasta file should succeed #{fasta_file.errors.full_messages.to_sentence}"
      assert File.exists?( fasta_file.fasta.path ), "File should exist after create"
      @job =  Jobs::CleanFileWithBlast.new("Clean #{fasta_file.label}",
        {:fasta_file_id => fasta_file.id })
    end

    should "clean job should run" do
     assert_not_nil @job.do_perform
    end
  end
end
