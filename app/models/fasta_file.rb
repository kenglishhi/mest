class FastaFile < ActiveRecord::Base
  has_attached_file :fasta
  has_one :biodatabase

  belongs_to :user
  belongs_to :project

  validates_presence_of :project_id


  before_validation :set_label
  before_destroy :remove_fasta_dbs

  def self.generate_fasta(biodatabase_args)

    if biodatabase_args.is_a? Array
      biodatabases = biodatabase_args
      label = biodatabases.map{|db|db.name}.join('-')
      
      filename =  "#{self.temp_path}/Combined-#{label}.fasta"
      self.write_sequences_to_file(biodatabases, filename)
      fasta_file_handle = File.new(filename,"r")
      fasta_file = FastaFile.new
      fasta_file.fasta = fasta_file_handle
      fasta_file.project_id = biodatabases.first.biodatabase_group.project_id
      fasta_file.user_id = biodatabases.first.biodatabase_group.user_id
      fasta_file.is_generated = true
      fasta_file.save!
      fasta_file
    elsif biodatabase_args.is_a? Biodatabase
      biodatabase = biodatabase_args
      filename =  "#{self.temp_path}/#{biodatabase.name}.fasta"
      self.write_sequences_to_file(biodatabase, filename)
      fasta_file_handle = File.new(filename,"r")
      fasta_file = FastaFile.new
      fasta_file.fasta = fasta_file_handle
      fasta_file.project_id = biodatabase.biodatabase_group.project_id
      fasta_file.user_id = biodatabase.biodatabase_group.user_id
      fasta_file.is_generated = true
      fasta_file.save!

      biodatabase.fasta_file = fasta_file
      biodatabase.save
      fasta_file
    end
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
          if self.project.biodatabase_groups.empty?
            biodatabase_group = BiodatabaseGroup.create do |d|
              d.name = "Main Group"
              d.description = 'This is the main database group.'
              d.user = user
              d.project = project
            end
          else
            biodatabase_group = self.project.biodatabase_groups.first
          end

          self.biodatabase = Biodatabase.new(:name => File.basename(label),
            :fasta_file => self,
            :user => self.user,
            :biodatabase_group => biodatabase_group,
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

  def alignment_file_path
    self.fasta.path.sub(/fasta$/,'aln')
  end

  def alignemnt_exists?
    File.exists? alignment_file_path
  end

  def generate_alignment
    command = " clustalw -infile=#{self.fasta.path}"
    system(*command)
    alignment_file_path
  end

  def alignment_file_url
    self.fasta.url.sub(/fasta$/,'aln') if alignemnt_exists?
  end

  def alignment_exists?
    File.exists? alignment_file_path
  end

  def overwrite_fasta
    if self.fasta
      FastaFile.write_sequences_to_file(biodatabase, self.fasta.path )
    end
  end
  
end
