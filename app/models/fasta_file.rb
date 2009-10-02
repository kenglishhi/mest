class FastaFile < ActiveRecord::Base
  has_attached_file :fasta

  has_one :biodatabase

  belongs_to :user

  validates_uniqueness_of :label
  validates_presence_of :project_id

  belongs_to :project

  before_validation :set_label
  before_destroy :remove_fasta_dbs

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
              d.name = "Default Database Group 1 for project #{project.name}"
              d.description = 'This is the default database group.'
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

          ff = Bio::FlatFile.open(Bio::FastaFormat, self.fasta.path )
          ff.each do |entry|
            bioseq = Biosequence.new(:name => entry.definition, :seq => entry.seq,
              :alphabet => 'dna', :length => entry.seq.length)
            bioseq.save!
            self.biodatabase.biosequences << bioseq
            logger.error("[kenglish] bioseq.name = #{bioseq.name}")
          end
          self.biodatabase.save!
          logger.error("[kenglish] fasta_file.biodatabase_id = #{biodatabase.id}")
        end
      end
    end
  end

  def formatdb
    puts( "[kenglish] called formatdb fasta = #{fasta} File.exists?(fasta.path) = #{File.exists?(fasta.path)} ")

    if fasta and File.exists?(fasta.path)
      args = " -i #{fasta.path} -p F -o F -n #{fasta.path} "
      puts "[kenglish] formatdb #{args}"
      `/usr/bin/formatdb  #{args}`
      #Paperclip.run "/usr/bin/formatdb",  args
      puts "[kenglish] Ran format db"
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

  def match_sequence_def(query_def, rewind_flag=false)
    count=0
    if self.biodatabase_id
      bioentries = Bioentry.sequence_in_database( query_def[0..39], biodatabase_id )
      return bioentries.first unless  bioentries.empty?
    end

    open_fasta_file unless @fasta_file_handle
    @fasta_file_handle.rewind if rewind_flag
    begin
      sequence = @fasta_file_handle.next_entry
      return unless sequence
      count =+ 1
    end  until query_def ==  sequence.definition
    sequence
  end
  def find_bioentry(query_def)
    if self.is_generated
      bioentry = BlastOutputEntry.find(:first,:include => :bioentry, :conditions => ['bioentry.name = ? ',query_def] ).bioentry
    else
      match_sequence_def(query_def)
      # search the file
    end
  end
  def find_biosequence(query_def)
    Biosequence.find_by_name(query_def)
  end

  def close_fasta_file
    @fasta_file_handle.close if @fasta_file_handle
  end
end
