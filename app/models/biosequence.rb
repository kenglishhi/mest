class Biosequence < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :id, :name, :alphabet, :length


  has_many :biodatabase_biosequences
  has_many :biodatabases, :through => :biodatabase_biosequences
  validates_presence_of :name
  validates_presence_of :alphabet
  validates_presence_of :seq
  

  def to_fasta
     ">#{name}\n#{seq}\n"
  end
  def to_s
    to_fasta
  end

end