require File.dirname(__FILE__) + '/../test_helper'

class BlastResultTest < ActiveSupport::TestCase
  should_have_attached_file :output
  should "test convenience methods" do
    Factory(:blast_result)
    blast_result = BlastResult.first
    filename = "16-blast-result.txt"
    tempfile = File.open(File.dirname(__FILE__) + "/../fixtures/files/#{filename}")

    blast_result.output = tempfile
    assert blast_result.valid?
    assert blast_result.save
    assert_not_nil blast_result
    assert_match /^#{blast_result.id}/, blast_result.normalized_output_file_name, "should begin with the id"
    assert_not_nil blast_result.output_file_name_display
    assert_not_nil blast_result.output_file_url

  end
end
