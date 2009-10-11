class Biosequence < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :id, :name, :alphabet, :length
  cattr_reader :per_page
  @@per_page = 200



  has_many :biodatabase_biosequences, :dependent => :destroy
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