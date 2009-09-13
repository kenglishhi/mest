class BiodatabaseLinkType < ActiveRecord::Base
  CLEANED = 'Cleaned'

  def self.cleaned
    find_by_name(CLEANED)
  end
  def authorized_for_destroy?
    [CLEANED].include? self.name
  end
end
