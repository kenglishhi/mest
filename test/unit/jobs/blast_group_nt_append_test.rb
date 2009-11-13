require File.dirname(__FILE__) + '/../../test_helper'

class Jobs::BlastGroupNtAppendTest < ActiveSupport::TestCase

   context "Blast db group against NR" do
    setup do
      @fasta_file = fasta_files(:fasta_files_006)
      @biodatabase_group   = biodatabase_groups(:biodatabase_groups_001)
    end
    context "Blast NT with default number_of_sequences_to_save" do
      setup do
        @db_count  =  @biodatabase_group.biodatabases.size
        @job =  Jobs::BlastGroupNtAppend.new("Blasting #{@biodatabase_group.name} against NR",
          {:biodatabase_group_id => @biodatabase_group.id,
            :user_id => users(:users_001).id,
            :project_id => users(:users_001).active_project.id})
        @number_of_blast_results = BlastResult.count
        @job.perform
      end
      should "Create add NR Sequences to DB" do
        assert_equal @number_of_blast_results + @db_count, BlastResult.count, "We should have a new biodatabase group"
      end

    end
    context "Blast NT with number_of_sequences_to_save of 20" do
      setup do
        @db_count  =  @biodatabase_group.biodatabases.size
        @number_of_sequences_to_save = 25
        @job =  Jobs::BlastGroupNtAppend.new("Blasting #{@biodatabase_group.name} against NR",
          {:biodatabase_group_id => @biodatabase_group.id,
            :user_id => users(:users_001).id,
            :project_id => users(:users_001).active_project.id,
            :number_of_sequences_to_save => @number_of_sequences_to_save })
        @number_of_blast_results = BlastResult.count
        @job.perform
      end
      should "Create add NR Sequences to DB" do
        assert_equal @number_of_blast_results +  @db_count, BlastResult.count, "We should have a new biodatabase group"
      end
    end
  end
end

