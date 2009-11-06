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

  context "Generate fasta file" do
    setup do
      @biodatabase = Biodatabase.create(
        :name => "New BioDB 33",
        :biodatabase_type => biodatabase_types(:biodatabase_types_001),
        :biodatabase_group => biodatabase_groups(:biodatabase_groups_001),
        :user => users(:users_001))

      @biodatabase.biosequences << biosequences(:biosequences_007)
      @biodatabase.biosequences << biosequences(:biosequences_006)
      @biodatabase.biosequences << biosequences(:biosequences_002)
      @biodatabase.save!
      FastaFile.generate_fasta @biodatabase
    end

    should "Generate a fasta file" do
      @biodatabase.reload
      assert_equal @biodatabase.biosequences.size,3, "Should have 3 sequences in the database"
      assert_not_nil @biodatabase.fasta_file, "Fasta File should not be nil."
      assert @biodatabase.destroy
    end
  end
  context "Overwrite fasta file" do
    setup do
      @biodatabase = biodatabases(:biodatabases_001)
     @biodatabase.rename_sequences("XXX")
      @biodatabase.fasta_file.overwrite_fasta

      FastaFile.generate_fasta @biodatabase
    end

    should "Generate a fasta file" do
      @biodatabase.reload
      assert_equal @biodatabase.biosequences.size,3, "Should have 3 sequences in the database"
      assert_not_nil @biodatabase.fasta_file, "Fasta File should not be nil."
      assert @biodatabase.destroy
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

