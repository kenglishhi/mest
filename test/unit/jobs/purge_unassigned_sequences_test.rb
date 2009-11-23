require File.dirname(__FILE__) + '/../../test_helper'

class Jobs::PurgeUnassignedSequencesTest < ActiveSupport::TestCase
  context "Purge Unassigned Sequences Test" do
    setup do
      @names = ['xxxx1','xxxx2']
      @names.each do | name| 
        seq = Biosequence.create :name => name, :alphabet => 'dna', :seq => 'ACGTACGT'
        assert seq.valid?
      end
      @old_count = Biosequence.count
      @job =  Jobs::PurgeUnassignedSequences.new("Purge those unassigned sequences")
    end

    should "Pure the unassigne sequences" do
      @job.perform
      assert_equal @old_count - @names.size, Biosequence.count
      @names.each do | name|
        assert_nil Biosequence.find_by_name name
      end
    end
  end
end

