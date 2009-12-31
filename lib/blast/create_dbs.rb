class Blast::CreateDbs < Blast::Base

  protected
  def init_files_and_databases
    @test_biodatabase = Biodatabase.find(Biodatabase.find(@params[:test_biodatabase_id]) )
    @test_fasta_file = @test_biodatabase.fasta_file
    @test_fasta_file.overwrite_fasta

    puts "Doing query for target_biodatabases = #{params[:target_biodatabase_ids]}"
    target_ids = []
    if params[:target_biodatabase_ids].is_a? Array
      target_ids = params[:target_biodatabase_ids]
    else
      target_ids = params[:target_biodatabase_ids].to_s.split(',')
    end
    @target_biodatabases = Biodatabase.all(:conditions => ["id in (?)",target_ids] )
    @target_fasta_file = FastaFile.new
    if @target_biodatabases.size == 1
      @target_fasta_file = @target_biodatabases.first.fasta_file
      @target_fasta_file.overwrite_fasta
    else
      # Generate a file with all the sequences
      @target_fasta_file = FastaFile.generate_fasta(@target_biodatabases)
    end
    if @test_fasta_file.nil? || @target_fasta_file.nil?
      raise "Target or Test Fasta File does not exist"
    end
    @target_fasta_file.formatdb
  end


  def do_run
    init_files_and_databases
    evalue = get_evalue 

    output_parent_biodatabase_name = params[:output_parent_biodatabase_name] ||
      "#{@test_fasta_file.biodatabase.name} vs #{@target_fasta_file.label}"

    @blast_result = new_blast_result("#{output_parent_biodatabase_name} Blast Result",@test_database)

    output_file_handle = Blast::Command.execute(:blastall, @blast_result, :test_file_path => @test_fasta_file.fasta.path,
      :target_file_path => @target_fasta_file.fasta.path,
      :evalue => evalue,
      :program => @params[:program],
      :output_file_prefix => output_parent_biodatabase_name.underscore)
    output_file_handle.open
    @blast_result.stopped_at = Time.now
    @blast_result.duration_in_seconds = (@blast_result.stopped_at - @blast_result.started_at)


    result_ff = Bio::FlatFile.open(output_file_handle)
    @matches = 0

    match_biodatabase_type = BiodatabaseType.find_by_name(BiodatabaseType::GENERATED_MATCH)

    output_parent_biodatabase  = Biodatabase.new
    Biodatabase.transaction do
      if Biodatabase.exists? :name => output_parent_biodatabase_name
        logger.error "output_parent_biodatabase_name exists! #{output_parent_biodatabase_name}"
        output_parent_biodatabase  = Biodatabase.find_by_name(output_parent_biodatabase_name)
      else
        logger.error "Creating output_parent_biodatabase_name #{output_parent_biodatabase_name}"
        output_parent_biodatabase = Biodatabase.create!(:name => output_parent_biodatabase_name,
          :project_id => @test_fasta_file.project_id,
          :parent => @test_fasta_file.biodatabase,
          :biodatabase_type => BiodatabaseType.database_group,
          :user_id => @params[:user_id])
      end

      @number_of_fastas = 0
      result_ff.each do |report|
        test_biosequence = Biosequence.find_by_name(report.query_def)
        
        first_flag = true
        child_biodatabase =nil
        report.each do |hit|

          if first_flag
            @number_of_fastas += 1
            new_db_name = "#{output_parent_biodatabase.name } #{"%03d" % @number_of_fastas}"
            child_biodatabase = Biodatabase.new(:name => new_db_name,
              :parent => output_parent_biodatabase,
              :project => output_parent_biodatabase.project,
              :biodatabase_type => match_biodatabase_type,
              :user_id => params[:user_id] )

            child_biodatabase.biosequences << test_biosequence
            first_flag = false
          end
          @matches += 1
          target_biosequence = Biosequence.find_by_name(hit.target_def)
          child_biodatabase.biosequences << target_biosequence
        end
        unless child_biodatabase.nil? 
          child_biodatabase.save!
          FastaFile.generate_fasta(child_biodatabase)
        end
      end
    end
    @blast_result.output = output_file_handle
    @blast_result.output_biodatabase = output_parent_biodatabase
    @blast_result.save!
    logger.error( "Saved blast Results ")
    @blast_result
  end


end
