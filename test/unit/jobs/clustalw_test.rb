require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::ClustalWTest < ActiveSupport::TestCase
  context "Clustalw test" do
    setup do

      @test_fasta_file = fasta_files(:fasta_files_001)
      @test_biodatabase   = @test_fasta_file.extract_sequences
      
      assert File.exists?( @test_biodatabase.fasta_file.fasta.path ), "test_fasta_file should exist."
      @job =  Jobs::Clustalw.new("Clustalw #{@test_biodatabase.name}",
        {:biodatabase_id => @test_biodatabase.id,
          :user_id => users(:users_001).id})
      @number_of_alignments = Alignment.count
    end

    should "Create new databases" do
      assert_not_nil @job.do_perform
      assert_equal @number_of_alignments+1 , Alignment.count, "Should generate a new alignment."
      assert_not_nil Alignment.last.report
      assert File.exists?(Alignment.last.aln.path)
    end
  end

end

