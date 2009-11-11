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
    end

    should "Create new databases" do
      @job.perform
      assert @test_fasta_file.alignment_exists?
    end
  end

end

