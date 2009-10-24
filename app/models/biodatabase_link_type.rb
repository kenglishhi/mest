class BiodatabaseLinkType < ActiveRecord::Base
  CLEANED = 'Cleaned'

  has_many :biodatabase_links
  def self.cleaned
    find_by_name(CLEANED)
  end
  def authorized_for_destroy?
     not [CLEANED].include? self.name
  end
end
