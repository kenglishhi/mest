require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::BlastAndCreateDbsTest < ActiveSupport::TestCase
  context "Blast 2 dbs and create databases" do
    setup do

      @test_fasta_file = fasta_files(:fasta_files_004)
      @target_fasta_file = fasta_files(:fasta_files_005)

      @test_biodatabase   = @test_fasta_file.extract_sequences
      @target_biodatabase =  @target_fasta_file.extract_sequences
      
      assert File.exists?( @test_biodatabase.fasta_file.fasta.path ), "test_fasta_file should exist."
      assert File.exists?( @target_biodatabase.fasta_file.fasta.path ), "target_fasta_file should exist."
      @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@test_biodatabase.name} against #{@target_biodatabase.name}",
        {:test_biodatabase_id => @test_biodatabase.id,
          :target_biodatabase_id => @target_biodatabase.id,
          :user_id => users(:users_001).id,
          :project_id => users(:users_001).active_project.id})
      @number_of_biodatabase_groups = BiodatabaseGroup.count
      @number_of_blast_results = BlastResult.count
    end

    should "Create new databases" do
      @job.perform
      assert_equal @number_of_biodatabase_groups+1, BiodatabaseGroup.count, "We should have a new biodatabase group"
      assert_equal @number_of_blast_results+1, BlastResult.count, "We should have a new biodatabase group"
      assert !BiodatabaseGroup.last.biodatabases.empty?, "There should not be any empty databases."
    end
  end

  context "Test that required params are checked" do
    setup do
      @biodatabase = biodatabases(:biodatabases_001)
      @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@biodatabase.name} against NOTHING",
        {:test_biodatabase_id => @biodatabase.id,:target_biodatabase_id => ""})
    end
    should "Raise Error when test_fasta_id parameter is missing" do
      assert_raise(RuntimeError) { @job.perform}
    end
  end
  context "Blast 2 identical dbs and create databases" do
    setup do
      @test_fasta_file = fasta_files(:fasta_files_004)
      @target_fasta_file = fasta_files(:fasta_files_004)

      @test_biodatabase   = @test_fasta_file.extract_sequences
      @target_biodatabase =  @target_fasta_file.extract_sequences

      assert File.exists?( @test_fasta_file.fasta.path ), "test_fasta_file should exist."
      assert File.exists?( @target_fasta_file.fasta.path ), "target_fasta_file should exist."

      @number_of_biodatabase_groups = BiodatabaseGroup.count
      @number_of_biodatabases = Biodatabase.count
      @number_of_blast_results = BlastResult.count
      @number_of_fasta_files = FastaFile.count

      @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@test_fasta_file.label} against #{@target_fasta_file.label} ",
        {:test_biodatabase_id => @test_biodatabase.id,
          :target_biodatabase_id => @target_biodatabase.id,
          :user_id => users(:users_001).id,
          :project_id => users(:users_001).active_project.id})
    end

    should "Create new databases" do
      @job.perform
      assert_equal @number_of_biodatabase_groups+1, BiodatabaseGroup.count, "We should have a new biodatabase group"
      assert_equal @number_of_blast_results+1, BlastResult.count, "We should have a new biodatabase group"
      assert_equal @number_of_fasta_files+1, FastaFile.count, "We should have a new fasta file"
      assert @number_of_biodatabases <  Biodatabase.count, "We should have new biodatabases "
      assert !BiodatabaseGroup.last.biodatabases.empty?, "There should not be any empty databases."
    end
  end




end

