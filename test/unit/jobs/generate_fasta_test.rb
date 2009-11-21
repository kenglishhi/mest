require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::GenerateFastaTest < ActiveSupport::TestCase
  context "Generate Fasta test" do
    setup do
      @test_biodatabase = biodatabases(:biodatabases_001)
      @job =  Jobs::GenerateFasta.new("Generate Fasta #{@test_biodatabase.name}",
        {:biodatabase_id => @test_biodatabase.id })
    end

    should "Generate fasta" do
      @job.perform
      @test_biodatabase.reload

      assert  File.exists? @test_biodatabase.fasta_file.fasta.path

    end
  end
  context "Generate Fasta test" do
    setup do
      @job =  Jobs::GenerateFasta.new("Generte Fasta FAIL!FAIL!")
    end

    should "Raise exception on Generate fasta" do
      assert_raise RuntimeError do
        @job.perform
      end
    end
  end


end

