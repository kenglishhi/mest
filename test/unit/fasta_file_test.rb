require File.dirname(__FILE__) + '/../test_helper'

class FastaFileTest < ActiveSupport::TestCase

  should_have_attached_file :fasta
  should_belong_to :user
  should_have_one :biodatabase

  should_validate_uniqueness_of :label

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

  context "Format DB should fail if permission are wrong" do
    setup do
      @fasta_file = FastaFile.new
      filename =  "Cambodia.fasta"
      tempfile = File.open(File.dirname(__FILE__) + "/../fixtures/files/#{filename}")

      @fasta_file.fasta = tempfile
      @fasta_file.project = projects(:projects_001)
      assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
    end
    should "Raise exception" do
      dir =  File.dirname(@fasta_file.fasta.path)
      `chmod 555 #{dir}`
      assert_raise Paperclip::PaperclipCommandLineError do
        @fasta_file.formatdb
      end
    end
  end


end

