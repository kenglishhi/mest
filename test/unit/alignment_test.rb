require File.dirname(__FILE__) + '/../test_helper'

class AlignmentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :biodatabase

  context "Test alignment with ClustalW"  do
    setup do
      @test_db = biodatabases(:biodatabases_001)
      @old_alignment_count = Alignment.count
      @new_aln  = Alignment.generate_alignment(@test_db,users(:users_001))
    end
    should "Generate a new alignment file" do
      assert @new_aln.aln
      assert File.exists?(@new_aln.aln.path)
      assert_equal @old_alignment_count + 1 , Alignment.count
      assert_not_nil @new_aln.report
    end
  end
end
