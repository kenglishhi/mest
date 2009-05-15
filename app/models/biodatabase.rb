class Biodatabase < ActiveRecord::Base
  belongs_to :biodatabase_typeS
  has_many :biosequences, :through => :biodatabase_biosequences
  validates_presence_of :name
end
