require File.dirname(__FILE__) + '/../test_helper'


class BiodatabaseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :biodatabase_type, :fasta_file, :user
  should_validate_presence_of :name,:biodatabase_type_id
	should_have_many :biodatabase_biosequences, :biosequences

end
