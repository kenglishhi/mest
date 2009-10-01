class Biodatabase < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :id, :name


  belongs_to :biodatabase_type
  belongs_to :biodatabase_group
  belongs_to :fasta_file
  belongs_to :user

  has_many :biodatabase_biosequences, :dependent => :destroy
  has_many :biosequences, :through => :biodatabase_biosequences
  has_many :biodatabase_links, :dependent => :destroy
  has_many :linked_biodatabase_links, :class_name =>'BiodatabaseLink', :foreign_key =>'linked_biodatabase_id', :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :biodatabase_type_id
  validates_presence_of :biodatabase_group_id

  validates_uniqueness_of :name

  def generate_fasta
    puts "Called generate_fasta"
    if fasta_file_id.nil?
      filename =  "#{name}.fasta"
      fasta_file_handle = File.new(filename,"w")
      biosequences.each do | seq |
        fasta_file_handle.puts(seq.to_fasta)
      end
      fasta_file_handle.close
      puts "generating fasta"

      fasta_file_handle = File.new(filename,"r")
      self.fasta_file = FastaFile.new
      self.fasta_file.fasta = fasta_file_handle
      self.fasta_file.project_id = biodatabase_group.project_id
      self.fasta_file.user_id = self.user_id
      self.fasta_file.is_generated = true
      self.fasta_file.save!
      puts "new id #{self.fasta_file.errors.full_messages.to_sentence} "
      save
    end
  end

end
