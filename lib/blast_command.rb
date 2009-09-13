class BlastCommand 

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
    @target_fasta_files = []
  end

  def run_clean
    raise "output_biodatabase can to be nil" unless @output_biodatabase

    @target_fasta_file = @test_fasta_file
    @test_fasta_file.extract_sequences if !@test_fasta_file.is_generated && @test_fasta_file.biodatabase.nil?
    @target_fasta_file.formatdb

    options={}
    options[:evalue] = @params[:evalue] || 0.001

    @blast_result = BlastResult.new(:name => "#{@output_biodatabase.name} Blast Result",
      :started_at => Time.now
    )
    output_file_handle = execute_blast_command(options)
    output_file_handle.open

    @blast_result.stopped_at = Time.now
    @blast_result.duration_in_seconds = (@blast_result.stopped_at - @blast_result.started_at)
#    @blast_result.output= output_file_handle

    result_ff = Bio::FlatFile.open(output_file_handle)
    @matches = @test_fasta_file.biodatabase.biosequences.size

    # Copy the sequences to the output_biodatabase
    @output_biodatabase.parent = @test_fasta_file.biodatabase
    @test_fasta_file.biodatabase.biosequences.each do | row |
      @output_biodatabase.biosequences << row
    end
    @output_biodatabase.save

    # Remove any hits
    result_ff.each do |report|
      test_biosequence = Biosequence.find_by_name(report.query_def)
      if @output_biodatabase.biosequences.include? test_biosequence
        report.each do |hit|
          unless hit.target_def == report.query_def
            target_biosequence = Biosequence.find_by_name(hit.target_def)
            @matches = @matches - 1
            @output_biodatabase.biosequences.delete( target_biosequence )
          end
        end
      end
    end
    @output_biodatabase.save
    BiodatabaseLink.create(:biodatabase =>@test_fasta_file.biodatabase,
      :linked_biodatabase => @output_biodatabase,
      :biodatabase_link_type => BiodatabaseLinkType.cleaned)

    @blast_result.output= output_file_handle
    @blast_result.save!
    @blast_result
#    output_file_handle.close
    #    logger.error( "[kenglish] output_biodatabase.errors.full_messages.to_sentence #{output_biodatabase.errors.full_messages.to_sentence} ")
    #    self.biodatabase_id = output_biodatabase.id
    #    save

  end
  def  save_blast_result(output_file_handle)
#    if @blast_result
#    end

  end

#  def run_command
#    options={}
#    options[:evalue] = self.evalue || 0.001
#
#    test_fasta_file.extract_sequences if !test_fasta_file.is_generated && test_fasta_file.biodatabase.nil?
#    target_fasta_file.extract_sequences if !target_fasta_file.is_generated && target_fasta_file.biodatabase.nil?
#    target_fasta_file.formatdb
#
#    output_file_handle = execute_blast_command(options)
#    output_file_handle.open
#    result_ff = Bio::FlatFile.open(output_file_handle)
#    @matches = 0
#    @number_of_fastas = 0
#
#    transaction do
#      output_biodatabase = Biodatabase.new(:name => biodatabase_name,
#        :biodatabase_type_id =>  biodatabase_type_id,
#        :parent => test_fasta_file.biodatabase)
#      output_biodatabase.save
#
#      self.biodatabase_id = output_biodatabase.id
#      save
#
#      match_biodatabase_type = BiodatabaseType.find_by_name("GENERATED-MATCH")
#      result_ff.each do |report|
#        test_biosequence = Biosequence.find_by_name(report.query_def)
#
#        first_flag = true
#        child_biodatabase =nil
#        report.each do |hit|
#          if first_flag
#            @number_of_fastas += 1
#            child_biodatabase = Biodatabase.new(:name => "#{output_biodatabase.name } #{@number_of_fastas}",
#              :biodatabase_type => match_biodatabase_type,
#              :parent => output_biodatabase)
#
#            child_biodatabase.biosequences << test_biosequence
#            first_flag = false
#          end
#          @matches += 1
#          target_biosequence = Biosequence.find_by_name(hit.target_def)
#          child_biodatabase.biosequences << target_biosequence
#        end
#        child_biodatabase.save unless child_biodatabase.nil? # no matches
#        return
#      end
#      output_biodatabase.save
#      puts "[kenglish] saved new database #{output_biodatabase.name} ( #{output_biodatabase.id} ) "
#    end
#    true
#  end


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

  private

  def execute_blast_command(options)
    command = " blastall -p blastn -i #{@test_fasta_file.fasta.path} -d #{@target_fasta_file.fasta.path} -e #{options[:evalue]}  -b 20 -v 20 "
    output_file_handle = Tempfile.new("#{@output_biodatabase.name}_Blast_Result.txt")
    output_file_handle.close(false)
    command <<  "-o  #{output_file_handle.path} "
    system(*command)
    output_file_handle.close
    output_file_handle
  end
  #
end
