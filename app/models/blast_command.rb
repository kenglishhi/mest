class BlastCommand < ActiveRecord::Base
  has_attached_file :output

  belongs_to :query_fasta_file, :class_name => 'FastaFile', :foreign_key => 'query_fasta_file_id'
  belongs_to :db_fasta_file,    :class_name => 'FastaFile', :foreign_key => 'db_fasta_file_id'
  belongs_to :biodatabase
  belongs_to :biodatabase_type

  validates_presence_of :query_fasta_file_id
  validates_presence_of :db_fasta_file_id
  validates_presence_of :evalue
  validates_presence_of :biodatabase_name

  attr_accessor :matches
  attr_accessor :number_of_fastas


  def run_command

  end
  def run_clean
    options={}
    options[:evalue] = self.evalue || 0.001
#    db_fasta_file.sequences
    puts  "db_fasta_file = #{db_fasta_file.inspect}"
    puts  "db_fasta_file = #{db_fasta_file.inspect}"
    db_fasta_file.extract_sequences if !db_fasta_file.is_generated && db_fasta_file.biodatabase.nil?
    query_fasta_file.extract_sequences if !query_fasta_file.is_generated && query_fasta_file.biodatabase.nil?
    db_fasta_file.formatdb

    output_file_handle = exec_command(options)
    output_file_handle.open
    result_ff = Bio::FlatFile.open(output_file_handle)
    @matches = 0
		result_biodatabase = Biodatabase.new(:name => biodatabase_name,
			:biodatabase_type_id =>  biodatabase_type_id )

    result_ff.each do |report|
      puts "query_def = #{report.query_def}"
      query_biosequence = Biosequence.find_by_name(report.query_def)
#      query_biosequence = query_fasta_file.find_biosequence(report.query_def)
#      puts "query_biosequence = #{query_biosequence.name} "
			first_flag = true
      report.each do |hit|
        if first_flag
  			  result_biodatabase.biosequences << query_biosequence
			    first_flag = false
				end
        @matches += 1
        db_biosequence = Biosequence.find_by_name(hit.target_def)
			  result_biodatabase.biosequences << db_biosequence
      end
		end
		result_biodatabase.save
		biodatabase_id = result_biodatabase.id
		save
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
        puts    "  #{tempfile.path} {ff.valid?}"
      #  fasta_grou
      end
    end
  end

  private

  def exec_command(options)
    command = " blastall -p blastn -i #{query_fasta_file.fasta.path} -d #{db_fasta_file.fasta.path} -e #{options[:evalue]}  -b 20 -v 20 "
    output_file_handle = Tempfile.new("blastout_#{id}")
    output_file_handle.close(false)
    command <<  "-o  #{output_file_handle.path} "
#    puts "[kenglish] output_file_handle.path = #{output_file_handle.path} "
#    puts "[kenglish]--------------------- "
#    puts "[kenglish] command = #{command} "
    system(*command)
#    puts "output_file_handle.path = #{output_file_handle.path}"
    output_file_handle.close
    new_output_file_name = "#{biodatabase_name}_blast_output.txt"
    FileUtils.cp(output_file_handle.path,new_output_file_name)
#    puts "new_output_file_name.path = #{new_output_file_name}"
    self.output = File.open(new_output_file_name)
    self.save
#    puts "self.output.path = #{self.output.path}"
    output_file_handle

  end

end
