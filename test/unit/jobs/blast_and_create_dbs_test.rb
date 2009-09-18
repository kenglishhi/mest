
require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::BlastAndCreateDbsTest < ActiveSupport::TestCase
  context "Blast 2 dbs and create databases" do
    setup do
      @test_fasta_file = fasta_files(:fasta_files_004)
      @target_fasta_file = fasta_files(:fasta_files_005)

      assert File.exists?( @test_fasta_file.fasta.path ), "test_fasta_file should exist."
      assert File.exists?( @target_fasta_file.fasta.path ), "target_fasta_file should exist."
      @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@test_fasta_file.label} against #{@target_fasta_file.label} ",
        {:test_fasta_file_id => @test_fasta_file.id,
         :target_fasta_file_id => @target_fasta_file.id,
         :user_id => users(:users_001).id})
      @number_of_biodatabase_groups = BiodatabaseGroup.count
    end

    should "Create new databases" do

     assert_not_nil @job.do_perform
     assert_equal @number_of_biodatabase_groups+1, BiodatabaseGroup.count, "We should have a new biodatabase group"
     assert !BiodatabaseGroup.last.biodatabases.empty?, "There should not be any empty databases."
    end
  end
  context "Test that required params are checked" do
    setup do
      @test_fasta_file = fasta_files(:fasta_files_001)
      @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@test_fasta_file.label} against NOTHING",
        {:test_fasta_file_id => @test_fasta_file.id,:target_fasta_file_id => ""})
    end
    should "Raise Error when test_fasta_id parameter is missing" do
      assert_raise(RuntimeError) { @job.do_perform}
    end
  end


end

