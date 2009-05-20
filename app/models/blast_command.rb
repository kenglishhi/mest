class BlastCommand < ActiveRecord::Base
  has_attached_file :output

  belongs_to :query_fasta_file, :class_name => 'FastaFile', :foreign_key => 'query_fasta_file_id'
  belongs_to :db_fasta_file,    :class_name => 'FastaFile', :foreign_key => 'db_fasta_file_id'
  belongs_to :biodatabase
  belongs_to :biodatabase_type

  validates_presence_of :biodatabase_type_id
	validates_presence_of :biodatabase_name
  validates_presence_of :query_fasta_file_id
	#  validates_presence_of :db_fasta_file_id
  validates_presence_of :evalue


  attr_accessor :matches
  attr_accessor :number_of_fastas
	before_validation_on_create :check_for_clean_upload_type

  def check_for_clean_upload_type
		if biodatabase_type.name == "UPLOADED-CLEANED"
      query_fasta_file ?  db_fasta_file_id = query_fasta_file.id : db_fasta_file_id =  query_fasta_file_id
  		puts query_fasta_file.label
      if biodatabase_name.blank?
        self.biodatabase_name =""
        self.biodatabase_name << (query_fasta_file ?  query_fasta_file.label : FastaFile.find(query_fasta_file_id).label)
    		self.biodatabase_name << "-CLEANED"
  		end
    end
  	logger.error("[kenglish]  self.biodatabase_name = --#{self.biodatabase_name}--" )
		puts query_fasta_file.label
  end
	def run
		puts biodatabase_type.name
		if biodatabase_type.name == "UPLOADED-CLEANED"
			run_clean
		else
			run_command
		end
	end

  def run_clean
    options={}
    options[:evalue] = self.evalue || 0.001
		#    db_fasta_file.sequences
    self.db_fasta_file = query_fasta_file
		puts query_fasta_file.label

    query_fasta_file.extract_sequences if !query_fasta_file.is_generated && query_fasta_file.biodatabase.nil?
    db_fasta_file.formatdb

    output_file_handle = exec_command(options)
    output_file_handle.open
    result_ff = Bio::FlatFile.open(output_file_handle)
    @matches = query_fasta_file.biodatabase.biosequences.size
    @number_of_fastas = 1
		result_biodatabase = Biodatabase.new(:name => biodatabase_name,
			:biodatabase_type =>  biodatabase_type,
		  :parent => query_fasta_file.biodatabase )
    puts "result_biodatabase #{result_biodatabase.valid?}.#{result_biodatabase.errors.full_messages.to_sentence }"
    query_fasta_file.biodatabase.biosequences.each do | row |
      result_biodatabase.biosequences << row
		end
    result_biodatabase.save
    result_ff.each do |report|
      query_biosequence = Biosequence.find_by_name(report.query_def)
			if result_biodatabase.biosequences.include? query_biosequence
				puts "report.query_def #{report.query_def}"
				report.each do |hit|
					puts "hit #{hit.target_def}"
					unless hit.target_def == report.query_def
						db_biosequence = Biosequence.find_by_name(hit.target_def)
						@matches = @matches - 1
						result_biodatabase.biosequences.delete( db_biosequence)
					end
				end
			end
		end
#    logger.error( "[kenglish] result sequences = #{result_biodatabase.biosequences.inspect} ")
		result_biodatabase.save
#    logger.error( "[kenglish] result_biodatabase.errors.full_messages.to_sentence #{result_biodatabase.errors.full_messages.to_sentence} ")
		self.biodatabase_id = result_biodatabase.id
		save
		logger.error("[kenglish] saved self.biodatabase.id = #{self.biodatabase.id} " )

  end
  def run_command
    options={}
    options[:evalue] = self.evalue || 0.001

    query_fasta_file.extract_sequences if !query_fasta_file.is_generated && query_fasta_file.biodatabase.nil?
    db_fasta_file.extract_sequences if !db_fasta_file.is_generated && db_fasta_file.biodatabase.nil?
    db_fasta_file.formatdb

    output_file_handle = exec_command(options)
    output_file_handle.open
    result_ff = Bio::FlatFile.open(output_file_handle)
    @matches = 0
    @number_of_fastas = 0

		transaction do
		result_biodatabase = Biodatabase.new(:name => biodatabase_name,
			:biodatabase_type_id =>  biodatabase_type_id,
		  :parent => query_fasta_file.biodatabase)
    result_biodatabase.save

		self.biodatabase_id = result_biodatabase.id
		save

    match_biodatabase_type = BiodatabaseType.find_by_name("GENERATED-MATCH")
    result_ff.each do |report|
      query_biosequence = Biosequence.find_by_name(report.query_def)

			first_flag = true
			child_biodatabase =nil
      report.each do |hit|
        if first_flag
					@number_of_fastas += 1
          child_biodatabase = Biodatabase.new(:name => "#{result_biodatabase.name } #{@number_of_fastas}",
			      :biodatabase_type => match_biodatabase_type,
					  :parent => result_biodatabase)

  			  child_biodatabase.biosequences << query_biosequence
			    first_flag = false
				end
        @matches += 1
        db_biosequence = Biosequence.find_by_name(hit.target_def)
			  child_biodatabase.biosequences << db_biosequence
      end
      child_biodatabase.save unless child_biodatabase.nil? # no matches
		  return
		end
		result_biodatabase.save
		self.biodatabase_id = result_biodatabase.id
		logger.error("[kenglish] saved self.biodatabase.id = #{self.biodatabase.id} " )
		self.save
		end
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
