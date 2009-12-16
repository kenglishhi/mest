require File.dirname(__FILE__) + '/../test_helper'


class BiodatabaseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :biodatabase_type, :fasta_file, :user
  should_validate_presence_of :name,:biodatabase_type_id
	should_have_many :biodatabase_biosequences, :biosequences


  context "Should Clear References" do
    setup do
      @biodatabase = biodatabases(:biodatabases_001)
      @biosequence_count = Biosequence.count
      @my_sequence_count = @biodatabase.biosequences.size
      @biodatabase.destroy
    end
    should "Clear fasta file and sequences" do

      assert true
      # TODO: implement this!
#      assert_equal( @biosequence_count - @my_sequence_count, Biosequence.count)
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
  end
  should "Destory a standalone database" do
   biodatabase = Biodatabase.create(
        :name => "New BioDB 33",
        :biodatabase_type => biodatabase_types(:biodatabase_types_001),
        :project => projects(:projects_001),
        :user => users(:users_001))
    assert biodatabase.destroy
  end

end
