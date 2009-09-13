class BiodatabaseLink < ActiveRecord::Base

  belongs_to :biodatabase, :class_name => 'Biodatabase', :foreign_key => 'biodatabase_id'
  belongs_to :linked_biodatabase, :class_name => 'Biodatabase', :foreign_key => 'linked_biodatabase_id'
  belongs_to :biodatabase_link_type

end
