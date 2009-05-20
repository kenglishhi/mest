class Biosequence < ActiveRecord::Base
  has_many :biodatabase_biosequences
  has_many :biodatabases, :through => :biodatabase_biosequences
  validates_presence_of :name
  validates_presence_of :alphabet
  validates_presence_of :seq
  

  def to_fasta
     ">#{name}\n#{seq}\n"
  end

end