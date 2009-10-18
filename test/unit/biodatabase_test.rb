require File.dirname(__FILE__) + '/../test_helper'


class BiodatabaseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :biodatabase_type, :fasta_file, :user
  should_validate_presence_of :name,:biodatabase_type_id
	should_have_many :biodatabase_biosequences, :biosequences

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
      @biodatabase.generate_fasta
    end

    should "Generate a fasta file" do
      @biodatabase.reload
      assert_equal @biodatabase.biosequences.size,3, "Should have 3 sequences in the database"
      assert_not_nil @biodatabase.fasta_file, "Fasta File should not be nil."
      assert @biodatabase.destroy
    end
  end
  context "Should Clear References" do
    setup do
      @biodatabase = biodatabases(:biodatabases_001)
      @biosequence_count = Biosequence.count
      @my_sequence_count = @biodatabase.biosequences.size
      @biodatabase.destroy
    end
    should "Clear fasta file and sequences" do

      assert_equal( @biosequence_count - @my_sequence_count, Biosequence.count)
    end
  end
  def test_number_of_sequences
    biodatabase = biodatabases(:biodatabases_001)
    assert_equal  biodatabase.biosequences.size, biodatabase.number_of_sequences
  end
  def test_rename_sequences
    new_prefix = "KEV_"
    biodatabase = biodatabases(:biodatabases_001)
    biodatabase.rename_sequences(new_prefix)
    biodatabase.biosequences.each do | seq|
      assert_match /^#{new_prefix}/, seq.name, "Sequence name should start with #{new_prefix}"
    end
    assert_equal  biodatabase.biosequences.size, biodatabase.number_of_sequences
  end
  should "Destory a standalone database" do
   biodatabase = Biodatabase.create(
        :name => "New BioDB 33",
        :biodatabase_type => biodatabase_types(:biodatabase_types_001),
        :biodatabase_group => biodatabase_groups(:biodatabase_groups_001),
        :user => users(:users_001))
    assert biodatabase.destroy
  end

end
