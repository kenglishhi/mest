require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::ExtractSequencesTest < ActiveSupport::TestCase
  context "Extract sequences from a Fasta File" do
    setup do
      filename =  "EST_Clade_C_3.fasta"
      tempfile = File.open(File.dirname(__FILE__) + "/../../fixtures/files/#{filename}")

      @fasta_file = FastaFile.new
      @fasta_file.fasta = tempfile
      @fasta_file.project = projects(:projects_001)
      assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
      assert File.exists?( @fasta_file.fasta.path ), "File should exist after create"
      @job =  Jobs::ExtractSequences.new("Clean #{@fasta_file.label}",
        {:fasta_file_id => @fasta_file.id, 
          :user_id => users(:users_001).id,
          :project_id => users(:users_001).active_project.id})
    end

    should "extract job should run" do
     @job.perform
     assert FastaFile.find(@job.params[:fasta_file_id] ).biodatabase.biosequences.size > 0
    end
  end

  context "Extract Cambodia Fasta File" do
    setup do
      filename =  "Cambodia.fasta"
      tempfile = File.open(File.dirname(__FILE__) + "/../../fixtures/files/#{filename}")

      @fasta_file = FastaFile.new
      @fasta_file.fasta = tempfile
      @fasta_file.project = projects(:projects_001)
      assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
      assert File.exists?( @fasta_file.fasta.path ), "File should exist after create"
      @job =  Jobs::ExtractSequences.new("Clean #{@fasta_file.label}",
        {:fasta_file_id => @fasta_file.id,
          :user_id => users(:users_001).id,
          :project_id => users(:users_001).active_project.id})
    end

    should "extract job should run" do
     @job.perform
     assert FastaFile.find(@job.params[:fasta_file_id] ).biodatabase.biosequences.size > 0
    end
  end

end
