require File.dirname(__FILE__) + '/../test_helper'

class FastaFileTest < ActiveSupport::TestCase

  should_have_attached_file :fasta
  should_belong_to :user
  should_have_one :biodatabase


  context "Format DB should fail if no fasta file exists" do
    setup do
      @fasta_file = FastaFile.new
      @fasta_file.project = projects(:projects_001)
      assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
    end
    should "Raise exception" do
      assert_raise RuntimeError do
        @fasta_file.formatdb
      end
    end
  end

  should "do a save" do
    @fasta_file = FastaFile.new
    filename =  "Cambodia.fasta"
    tempfile = File.open(File.dirname(__FILE__) + "/../fixtures/files/#{filename}")

    @fasta_file.fasta = tempfile
    @fasta_file.project = projects(:projects_001)
    assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
  end
  should "extract some sequences" do
    filename =  "Cambodia.fasta"
    tempfile = File.open(File.dirname(__FILE__) + "/../fixtures/files/#{filename}")

    @fasta_file = FastaFile.new
    @fasta_file.fasta = tempfile
    @fasta_file.project = projects(:projects_001)
    assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
    assert File.exists?( @fasta_file.fasta.path ), "File should exist after create"
    @fasta_file.extract_sequences

  end

end

