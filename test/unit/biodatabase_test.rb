require File.dirname(__FILE__) + '/../test_helper'


class BiodatabaseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :biodatabase_type, :fasta_file, :user
  should_validate_presence_of :name,:biodatabase_type_id
	should_have_many :biodatabase_biosequences, :biosequences

  context "Generate fasta file" do
    setup do
      @biodatabase = Biodatabase.create(
        :name => "New BioDB",
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
    end
  end

end
