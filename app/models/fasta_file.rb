class FastaFile < ActiveRecord::Base
  has_attached_file :fasta
  validates_uniqueness_of :label
  has_one :biodatabase, :dependent => :destroy
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
    if fasta  # and File.exists?(fasta.path)
      unless biodatabase
        self.biodatabase = Biodatabase.find_by_name(File.basename(label)  ) || Biodatabase.create(:name => File.basename(label), :fasta_file => self  )
        logger.error("[kenglish] fasta_file.biodatabase_id = #{biodatabase.id}")
        save
        unless self.biodatabase.fasta_file == self
          self.biodatabase.fasta_file = self
          self.biodatabase.save
        end

        logger.error("[kenglish] new biodatabase.fasta_file.id = #{self.biodatabase.fasta_file.inspect}")

      end
      self.biodatabase.load_fasta
    end
    #    Bioentry.load_fasta fasta.path
  end

  def formatdb
    puts "called formatdb fasta = #{fasta} File.exists?(fasta.path) = #{File.exists?(fasta.path)} "
    if fasta and File.exists?(fasta.path)
      args = " -i #{fasta.path} -p F -o F -n #{fasta.path} "
      puts "[kenglish] HELLO KEVIN  #{fasta.path} args = #{args}"
      Paperclip.run "formatdb",  args
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

  def close_fasta_file
    @fasta_file_handle.close if @fasta_file_handle
  end
end
