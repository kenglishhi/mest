class BiodatabaseType < ActiveRecord::Base
  has_many :biodatabase
  validates_presence_of :name

end
