
require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::BlastAndCreateDbsTest < ActiveSupport::TestCase
  context "Blast 2 dbs and create databases" do
    setup do
      @test_fasta_file = fasta_files(:fasta_files_001)
      @target_fasta_file = fasta_files(:fasta_files_002)

      assert File.exists?( @test_fasta_file.fasta.path ), "test_fasta_file should exist."
      assert File.exists?( @target_fasta_file.fasta.path ), "target_fasta_file should exist."
      @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@test_fasta_file.label} against #{@target_fasta_file.label} ",
        {:test_fasta_file_id => @test_fasta_file.id,:target_fast_file_id => @target_fasta_file.id })
    end

    should "Create new databases" do
     assert_not_nil @job.do_perform
    end
  end
end
