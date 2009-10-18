require File.dirname(__FILE__) + '/../../test_helper'
class Jobs::RenameSequencesInDbTest < ActiveSupport::TestCase
  context "Testing rename sequences in db" do
    setup do
      @new_prefix = "KEV_"
      @biodatabase = biodatabases(:biodatabases_001)
      @job =  Jobs::RenameSequencesInDb.new("Rename sequences in database #{@biodatabase.name}",
        {:biodatabase_id => @biodatabase.id, :user_id => users(:users_001).id,:prefix=>@new_prefix })
    end

    should "Rename sequencess in db" do
      assert_not_nil @job.do_perform
      @biodatabase.biosequences.each do | seq|
        assert_match /^#{@new_prefix}/, seq.name, "Sequence name should start with #{@new_prefix}"
      end
    end
  end
end



