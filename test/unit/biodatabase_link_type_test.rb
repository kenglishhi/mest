require File.dirname(__FILE__) + '/../test_helper'

class BiodatabaseLinkTypeTest < ActiveSupport::TestCase
  should_have_many :biodatabase_links

  should "test convenience methods" do
   cleaned_type = BiodatabaseLinkType.cleaned
   assert_not_nil cleaned_type
   assert !cleaned_type.authorized_for_destroy?
  end
end
