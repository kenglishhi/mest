class Biosequence < ActiveRecord::Base
  has_many :biodatabase_sequences
  has_many :biodatabases, :through => :biodatabase_sequences
  validates_presence_of :name
  validates_presence_of :alphabet
  validates_presence_of :seq
  


end