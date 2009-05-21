class BiodatabaseType < ActiveRecord::Base
  has_many :biodatabases
  validates_presence_of :name
end
