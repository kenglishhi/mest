class Biodatabase < ActiveRecord::Base
  include ExtJS::Model
  acts_as_tree
  extjs_fields :id,:name,:created_at, :number_of_sequences, :fasta_file_name_display,:fasta_file_url, :alignment_file_url
  cattr_reader :per_page
  @@per_page = 10

  belongs_to :biodatabase_type
  belongs_to :project
  belongs_to :fasta_file
  belongs_to :user

  has_many :biodatabase_biosequences
  has_one  :alignment
  has_many :biosequences, :through => :biodatabase_biosequences, :order => 'name'
  has_many :biodatabase_links, :dependent => :destroy
  has_many :linked_biodatabase_links, :class_name =>'BiodatabaseLink', :foreign_key =>'linked_biodatabase_id', :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :biodatabase_type_id
  validates_presence_of :project_id

  #  validates_uniqueness_of :name
  before_destroy :clear_references
  named_scope :by_project, lambda { |project_id| { 
      :conditions => ['project_id = ?', project_id],
      :order => 'biodatabases.name'
    } }

  def ext_tree
    self.children
    tree_data = {
      :text =>  self.name,
      :leaf => self.children.empty?,
      :id => self.id,
      :expandable => !self.children.empty?,
      :db_type=> self.biodatabase_type.name,
      :resource => 'biodatabase'
    }
    unless self.children.empty?
      tree_data[:children] = self.children.map{|child| child.ext_tree}
    end
    tree_data
  end
  def clear_references
    BiodatabaseBiosequence.delete_all(["biodatabase_id = ? " ,self.id])
    fasta_file.destroy if fasta_file && fasta_file.is_generated?
  end

	def number_of_sequences
    self.biosequences.count
	end
  def fasta_file_name_display
    File.basename(self.fasta_file.fasta.to_s) if fasta_file
  end
  def fasta_file_url
    self.fasta_file.fasta.url if fasta_file
  end
  def alignment_file_url
    self.fasta_file.alignment_file_url if fasta_file
  end

  def rename_sequences(prefix)
    padding = Math.log10(self.biosequences.size).to_i + 1
    self.biosequences.each_index do |i|
      new_name = "#{prefix}#{"%0#{padding}d" %   (i+1)  }"
      logger.error("new name = #{new_name}")
      biosequences[i].name = new_name
      biosequences[i].save!
    end
  end

end
