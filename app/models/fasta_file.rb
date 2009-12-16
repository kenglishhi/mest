class FastaFile < ActiveRecord::Base
  include ExtJS::Model

  extjs_fields :id, :label, :alignment_file_name_display, :alignment_file_url,
    :fasta_file_name_display, :fasta_file_url,:fasta_file_size_display, :created_at

  has_attached_file :fasta
  has_one :biodatabase

  belongs_to :user
  belongs_to :project

  validates_presence_of :project_id

  before_validation :set_label
  before_destroy :remove_fasta_dbs

  named_scope :with_alignments, :conditions => 'alignment_flag = 1'

  def self.generate_fasta(biodatabase_args)
    fasta_file = nil
    if biodatabase_args.is_a? Array
      biodatabases = biodatabase_args
      label = biodatabases.map{|db|db.name}.join('-')
      filename =  "#{self.temp_path}/Combined-#{label}.fasta"
      self.write_sequences_to_file(biodatabases, filename)
      fasta_file_handle = File.new(filename,"r")
      fasta_file = FastaFile.new
      fasta_file.fasta = fasta_file_handle
      fasta_file.project_id = biodatabases.first.project_id
      fasta_file.user_id = biodatabases.first.project.user_id
      fasta_file.is_generated = true
      fasta_file.save!
    elsif biodatabase_args.is_a? Biodatabase
      biodatabase = biodatabase_args
      filename =  "#{self.temp_path}/#{biodatabase.name}.fasta"
      self.write_sequences_to_file(biodatabase, filename)
      fasta_file_handle = File.new(filename,"r")
      fasta_file = FastaFile.new
      fasta_file.fasta = fasta_file_handle
      fasta_file.project_id = biodatabase.project_id
      fasta_file.user_id = biodatabase.project.user_id
      fasta_file.is_generated = true
      fasta_file.save!

      biodatabase.fasta_file = fasta_file
      biodatabase.save
    end
    fasta_file
  end

  def self.write_sequences_to_file(biodatabase_arg, filename)
    fasta_file_handle = File.new(filename,"w+")
    if biodatabase_arg.is_a? Array
      biodatabases = biodatabase_arg
      biodatabases.each do | biodatabase | 
        biodatabase.biosequences.each do | seq |
          fasta_file_handle.puts(seq.to_fasta)
        end
      end
    elsif biodatabase_arg.is_a? Biodatabase
      biodatabase = biodatabase_arg
      biodatabase.biosequences.each do | seq |
        fasta_file_handle.puts(seq.to_fasta)
      end
    end

    fasta_file_handle.close
  end

  def fasta_file_size_display
    return "#{self.fasta_file_size}" if self.fasta_file_size < 1024
    file_size = self.fasta_file_size * 1.0
    unit = "B"
    units = ["GB","MB","KB"]
    while file_size >= 1024.0
      file_size = (file_size) / 1024
      unit=units.pop
    end
    "#{sprintf("%.#{2}f", file_size)} #{unit}"
  end

  def self.temp_path
    File.dirname(__FILE__) + '/../../tmp'
  end

  def is_generated?
    # looks prettier
    is_generated
  end

  def set_label
    if self.label.blank?
      if fasta_file_name && fasta_file_name.match(/\.fasta$/)
        self.label = fasta_file_name.sub(/\.fasta$/, '')
        logger.error("[kenglish] setting label  #{self.label}")
      end
    end
  end

  def extract_sequences
    logger.error("[kenglish] Called Extract Sequence")
    if fasta
      unless self.biodatabase
        transaction do
          if self.project.biodatabases.empty?
            parent_db = Biodatabase.create! do
              d.name = 'Databases'
              d.description = 'This is the main database group.'
              d.user = user
              d.project = project
              d.biodatabase_type = BiodatabaseType.database_group
          end
        else
          parent_db = self.project.biodatabases.first
        end

        self.biodatabase = Biodatabase.new(:name => File.basename(label),
            :fasta_file => self,
            :user => self.user,
            :parent => parent_db,
            :project => project,
            :biodatabase_type => BiodatabaseType.find_by_name(BiodatabaseType::UPLOADED_RAW) )
        self.biodatabase.save!
        save!
      end

      #        transaction do
      ff = Bio::FlatFile.open(Bio::FastaFormat, self.fasta.path )
      ff.each do |entry|
        begin
          bioseq = Biosequence.new(:name => entry.definition,
              :seq => entry.seq,
              :alphabet => 'dna',
              :length => entry.seq.length,
              :original_name => entry.definition)
          bioseq.save!
        rescue ActiveRecord::RecordInvalid =>  e
          suffix = "_#{self.biodatabase.id}_#{self.biodatabase.biosequences.size}"
          if ((bioseq.name.size + suffix.size) > 255)
            bioseq.name = bioseq.name[0..(255 - suffix.size - 1)] + suffix
          else
            bioseq.name += suffix
          end
          bioseq.save!
        end
        self.biodatabase.biosequences << bioseq
      end
      self.biodatabase.save!
      logger.error("[kenglish] fasta_file.biodatabase_id = #{biodatabase.id}")
    end
    #      end
  end
  self.biodatabase
end

def formatdb
  if fasta && fasta.path && File.exists?(fasta.path)
    args = " -i #{fasta.path} -p F -o F -n #{fasta.path} "
    Paperclip.run "formatdb",  args
  else
    raise "FORMAT DB Error: No fasta file to format"
  end

  unless File.exists?(fasta.path+".nsq") &&
      File.exists?(fasta.path+".nin") &&
      File.exists?(fasta.path+".nhr")
    raise "FORMAT DB Error: result files do not exist"
  end
end

def remove_fasta_dbs
  extensions = ["nhr", "nsq", "nil"]
  extensions.each do | extension |
    dbfile = "#{fasta.path}.#{extension}"
    File.delete dbfile  if File.exist? dbfile
  end
end

def open_fasta_file
  @fasta_file_handle = Bio::FlatFile.auto(self.fasta.path)
  @fasta_file_handle
end

def close_fasta_file
  @fasta_file_handle.close if @fasta_file_handle
end


def generate_alignment
  command = " clustalw -quiet -infile=#{self.fasta.path}"
  system(*command)
  self.alignment_flag = true
  self.save!
  alignment_file_path
end

def alignment_file_url
  self.fasta.url.sub(/fasta$/,'aln') if alignment_exists?
end
def  alignment_file_name_display
  File.basename(alignment_file_path)
end
def fasta_file_url
  self.fasta.url
end
def fasta_file_name_display
  fasta_file_name
end

def alignment_file_path
  self.fasta.path.sub(/fasta$/,'aln')
end

def alignment_exists?
  does_exists = File.exists? alignment_file_path
  if does_exists != self.alignment_flag
    # sync the value in the database if it does not exist
    self.alignment_flag = does_exists
    self.save!
  end
  self.alignment_flag
end

def overwrite_fasta
  if self.fasta
    FastaFile.write_sequences_to_file(biodatabase, self.fasta.path )
  end
end
end
