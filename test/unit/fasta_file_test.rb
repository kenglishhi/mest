require File.dirname(__FILE__) + '/../test_helper'

class FastaFileTest < ActiveSupport::TestCase

  should_have_attached_file :fasta
  should_belong_to :user
  should_have_one :biodatabase
  should_validate_presence_of :project_id

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

  context "Generate fasta file from multiple databases" do
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
      @biodatabases = [@biodatabase, biodatabases(:biodatabases_001),biodatabases(:biodatabases_002)  ]
      FastaFile.generate_fasta @biodatabases
    end

    should "Generate a fasta file" do
      new_fasta_file = FastaFile.last
      assert_match /^Combined/, new_fasta_file.fasta_file_name, "Fasta file name should contain the text combined"
#      assert_equal @biodatabase.biosequences.size,3, "Should have 3 sequences in the database"
##      assert_not_nil @biodatabase.fasta_file, "Fasta File should not be nil."
      assert @biodatabase.destroy
    end
  end



  context "Overwrite fasta file" do
    setup do
      @prefix = 'xYxY'
      @biodatabase = biodatabases(:biodatabases_001)
      @biodatabase.rename_sequences(@prefix)
      @biodatabase.fasta_file.overwrite_fasta

#      FastaFile.generate_fasta @biodatabase
    end

    should "Generate a fasta file" do
      @biodatabase.reload
      assert_equal @biodatabase.biosequences.size,3, "Should have 3 sequences in the database"
      assert_not_nil @biodatabase.fasta_file, "Fasta File should not be nil."
    end
  end

  should "gracefully handle duplicate names" do

    def create_cambodia
      @fasta_file = FastaFile.new
      filename =  "Cambodia.fasta"
      tempfile = File.open(File.dirname(__FILE__) + "/../fixtures/files/#{filename}")

      @fasta_file.fasta = tempfile
      @fasta_file.project = projects(:projects_001)
      assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
      @old_db_count = Biodatabase.count
      @fasta_file.extract_sequences
      assert_equal @old_db_count + 1,  Biodatabase.count
      @fasta_file.biodatabase
    end
    db1 = create_cambodia
    db2 =  create_cambodia
    assert_equal db1.biosequences.size, db2.biosequences.size

  end


  should "do a save" do
    @fasta_file = FastaFile.new
    filename =  "Cambodia.fasta"
    tempfile = File.open(File.dirname(__FILE__) + "/../fixtures/files/#{filename}")

    @fasta_file.fasta = tempfile
    @fasta_file.project = projects(:projects_001)
    assert @fasta_file.save, "Saving fasta file should succeed #{@fasta_file.errors.full_messages.to_sentence}"
  end

  should "Generate a new file" do
    fasta_file = FastaFile.generate_fasta [biodatabases(:biodatabases_001),biodatabases(:biodatabases_002)]
    assert File.exists? fasta_file.fasta.path

  end



end

