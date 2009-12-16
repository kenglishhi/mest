require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::BlastAndCreateDbsTest < ActiveSupport::TestCase
  context "Blast 2 dbs and create databases" do
    setup do
      @test_fasta_file = fasta_files(:fasta_files_004)
      @target_fasta_file = fasta_files(:fasta_files_005)

      @test_biodatabase   = @test_fasta_file.extract_sequences
      @target_biodatabase =  @target_fasta_file.extract_sequences
    end
    context "test create dbs 1" do
      setup do
        assert File.exists?( @test_biodatabase.fasta_file.fasta.path ), "test_fasta_file should exist."
        assert File.exists?( @target_biodatabase.fasta_file.fasta.path ), "target_fasta_file should exist."
        @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@test_biodatabase.name} against #{@target_biodatabase.name}",
          {:test_biodatabase_id => @test_biodatabase.id,
            :target_biodatabase_ids => @target_biodatabase.id,
            :user_id => users(:users_001).id,
            :project_id => users(:users_001).active_project.id})
        @number_of_blast_results = BlastResult.count
        @job.perform
      end

      should "Create new databases" do
        assert_equal @number_of_blast_results+1, BlastResult.count, "We should have a new biodatabase group"
      end
    end
    context "Blast 2 identical dbs and create databases" do
      setup do
        @target_fasta_file = fasta_files(:fasta_files_004)
        @target_biodatabase =  @target_fasta_file.extract_sequences

        assert File.exists?( @test_fasta_file.fasta.path ), "test_fasta_file should exist."
        assert File.exists?( @target_fasta_file.fasta.path ), "target_fasta_file should exist."

        @number_of_biodatabases = Biodatabase.count
        @number_of_blast_results = BlastResult.count
        @number_of_fasta_files = FastaFile.count

        @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@test_fasta_file.label} against #{@target_fasta_file.label} ",
          {:test_biodatabase_id => @test_biodatabase.id,
            :target_biodatabase_ids => @target_biodatabase.id,
            :user_id => users(:users_001).id,
            :project_id => users(:users_001).active_project.id})
        @job.perform
      end

      should "Create new databases" do
        assert_equal @number_of_blast_results+1, BlastResult.count, "We should have a new biodatabase group"
        assert_equal @number_of_fasta_files+1, FastaFile.count, "We should have a new fasta file"
        assert @number_of_biodatabases <  Biodatabase.count, "We should have new biodatabases "
      end
    end
    context "Blast with 3dbs at the target" do
      setup do
        target_biodatabases = [@target_biodatabase, biodatabases(:biodatabases_001),biodatabases(:biodatabases_002)]
        assert File.exists?( @test_fasta_file.fasta.path ), "test_fasta_file should exist."
        assert File.exists?( @target_fasta_file.fasta.path ), "target_fasta_file should exist."

        @number_of_biodatabases = Biodatabase.count
        @number_of_blast_results = BlastResult.count
        @number_of_fasta_files = FastaFile.count

        @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@test_fasta_file.label} against #{@target_fasta_file.label} ",
          {:test_biodatabase_id => @test_biodatabase.id,
           :target_biodatabase_ids => target_biodatabases.map{|db|db.id}.join(','),
           :user_id => users(:users_001).id,
           :project_id => users(:users_001).active_project.id})
        @job.perform
      end

      should "Create new databases" do
        assert_equal @number_of_blast_results+1, BlastResult.count, "We should have a new biodatabase group"
        assert_equal @number_of_fasta_files + 2, FastaFile.count, "We should have a 2 new fasta file"
        assert @number_of_biodatabases <  Biodatabase.count, "We should have new biodatabases "
      end
    end

  end


  context "Test that required params are checked" do
    setup do
      @biodatabase = biodatabases(:biodatabases_001)
      @job =  Jobs::BlastAndCreateDbs.new("Blasting #{@biodatabase.name} against NOTHING",
        {:test_biodatabase_id => @biodatabase.id,:target_biodatabase_ids => ""})
    end
    should "Raise Error when test_fasta_id parameter is missing" do
      assert_raise(RuntimeError) { @job.perform}
    end
  end
end