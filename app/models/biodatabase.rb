class Biodatabase < ActiveRecord::Base
	acts_as_tree
  belongs_to :biodatabase_type
  belongs_to :fasta_file
	has_many :biodatabase_biosequences
  has_many :biosequences, :through => :biodatabase_biosequences
  validates_presence_of :name
  validates_presence_of :biodatabase_type_id
end
