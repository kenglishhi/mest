class Blast::Base

  attr_accessor :test_fasta_file
  attr_accessor :target_fasta_files
  attr_accessor :target_fasta_file
  attr_accessor :output_biodatabase
  attr_accessor :blast_result

  attr_accessor :biodatabase
  attr_accessor :biodatabase_type
  attr_accessor :biodatabase_name

  attr_accessor :matches
  attr_accessor :number_of_fastas
  attr_accessor :params

  def initialize(p={})
    @params = p
    @params.delete_if {|key, value| value.blank? }
  end
  def logger
    Delayed::Worker.logger
  end
  def run
    do_run
  end

  protected

  def do_run
    raise "subclasses must implement"
  end

  def create_fastas
    if self.term
      fasta_groups = {}
      BioentryRelationship.find(:all, :conditions => ['term_id = ?', term.id], :order => 'subject_bioentry_id').each do | br |
        if fasta_groups[br.subject_bioentry.id]
          fasta_groups[br.subject_bioentry.id][:object_bioentries] << br.object_bioentry
        else
          fasta_groups[br.subject_bioentry.id] = {}
          fasta_groups[br.subject_bioentry.id][:subject_bioentry] = br.subject_bioentry
          fasta_groups[br.subject_bioentry.id][:object_bioentries] = [br.object_bioentry]
        end
      end
      @number_of_fastas = 0
      fasta_groups.each do |key, fasta_group|
        filename =   fasta_group[:subject_bioentry].name + ".fasta"
        tempfile = Tempfile.new(filename)
        tempfile.puts(fasta_group[:subject_bioentry].to_fasta)
        fasta_group[:object_bioentries].each do |  entry |
          unless  entry.name == fasta_group[:subject_bioentry].name
            tempfile.puts(entry.to_fasta)
          end
        end
        #        tempfile.close(false)

        fasta_file = FastaFile.new
        fasta_file.fasta = tempfile
        fasta_file.is_generated = true
        fasta_file.save
        @number_of_fastas = @number_of_fastas + 1
        #  fasta_grou
      end
    end
  end


end
