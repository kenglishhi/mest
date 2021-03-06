require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::BlastNtAppendTest < ActiveSupport::TestCase
  context "Blast db against NR" do
    setup do
      @fasta_file = fasta_files(:fasta_files_006)
      @biodatabase   = @fasta_file.extract_sequences
      @number_of_seqs = @biodatabase.biosequences.size
      assert File.exists?( @biodatabase.fasta_file.fasta.path ), "fasta_file should exist."
    end

    context "Blast NT with no program" do
      setup do
        @job =  Jobs::BlastNrNt.new("Blasting #{@biodatabase.name} against NR",
          {:biodatabase_id => @biodatabase.id,
            :user_id => users(:users_001).id,
            :ncbi_database => 'nt',
            :program => '',
            :project_id => users(:users_001).active_project.id})
        @number_of_blast_results = BlastResult.count

      end
      should "Create add NR Sequences to DB" do
        assert_raise RuntimeError do
          @job.perform
        end
        assert_equal @number_of_blast_results , BlastResult.count, "We should have a no new blast result"
      end
    end

    context "Blast NT with default number_of_sequences_to_save" do
      setup do
        @job =  Jobs::BlastNrNt.new("Blasting #{@biodatabase.name} against NR",
          {:biodatabase_id => @biodatabase.id,
            :user_id => users(:users_001).id,
            :ncbi_database => 'nt',
            :program => 'blastn',
            :project_id => users(:users_001).active_project.id})
        @number_of_blast_results = BlastResult.count

        @job.perform
        @biodatabase.reload
      end
      should "Create add NR Sequences to DB" do
        assert_equal @number_of_blast_results + 1, BlastResult.count, "We should have a new biodatabase group"
        assert_not_nil @biodatabase.parent.children.detect{ |db| db.name == 'NT Output'}, "Should generate a child db NT Output"
        nt_output = @biodatabase.parent.children.detect{ |db| db.name == 'NT Output'}
        assert nt_output.children.size > 0,"NT Output db should have more than one child"
      end
    end
    context "Blast NT with number_of_sequences_to_save of 20" do
      setup do
        @number_of_sequences_to_save = 25
        @job =  Jobs::BlastNrNt.new("Blasting #{@biodatabase.name} against NR",
          {:biodatabase_id => @biodatabase.id,
            :user_id => users(:users_001).id,
            :ncbi_database => 'nt',
            :program => 'blastn',
            :project_id => users(:users_001).active_project.id,
            :number_of_sequences_to_save => @number_of_sequences_to_save })
        @number_of_blast_results = BlastResult.count
        @job.perform
        @biodatabase.reload
      end
      should "Create add NR Sequences to DB" do
        assert_equal @number_of_blast_results + 1, BlastResult.count, "We should have a new biodatabase group"
      end
    end
    context "Blast NR with number_of_sequences_to_save of 20" do
      setup do
        @number_of_sequences_to_save = 25
        @job =  Jobs::BlastNrNt.new("Blasting #{@biodatabase.name} against NR",
          {:biodatabase_id => @biodatabase.id,
            :user_id => users(:users_001).id,
            :ncbi_database => 'nr',
            :program => 'blastx',
            :project_id => users(:users_001).active_project.id,
            :number_of_sequences_to_save => @number_of_sequences_to_save })
        @number_of_blast_results = BlastResult.count
        @job.perform
        @biodatabase.reload
      end
      should "Create add NR Sequences to DB" do
        assert_equal @number_of_blast_results + 1, BlastResult.count, "We should have a new biodatabase group"
      end
    end
  end
end

