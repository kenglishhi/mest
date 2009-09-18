class Biodatabase < ActiveRecord::Base

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

  def generate_fasta
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
      self.fasta_file.is_generated = true
      self.fasta_file.save
      puts "new id #{self.fasta_file.errors.full_messages.to_sentence} "
      save
    end
  end

end
