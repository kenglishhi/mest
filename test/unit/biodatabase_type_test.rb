require File.dirname(__FILE__) + '/../test_helper'


class BiodatabaseTypeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_have_many :biodatabases
  should_validate_presence_of :name
  should "test convenience methods" do
    BiodatabaseType.all.each do |type |
      if [BiodatabaseType::UPLOADED_RAW,
          BiodatabaseType::UPLOADED_CLEANED,
          BiodatabaseType::GENERATED_MASTER,
          BiodatabaseType::GENERATED_MATCH].include?(type.name)
        assert !type.authorized_for_destroy?, "Failed for #{type.name}"
      else
        assert type.authorized_for_destroy?, "Success for #{type.name}"
      end
    end
  end
end
