class Blast::CreateDbs < Blast::Base

  protected
  def init_files_and_databases
    @test_database = Biodatabase.find(Biodatabase.find(@params[:test_biodatabase_id]) )
    @target_database = Biodatabase.find(Biodatabase.find(@params[:target_biodatabase_id]) )
    @test_fasta_file = @test_database.fasta_file
    @target_fasta_file = @target_database.fasta_file
    @test_fasta_file.overwrite_fasta
    @target_fasta_file.overwrite_fasta
    if @test_fasta_file.nil? || @target_fasta_file.nil?
      raise "Target or Test Fasta File does not exist"
    end
    @target_fasta_file.formatdb
  end


  def do_run
    init_files_and_databases
    evalue = get_evalue 

    output_biodatabase_group_name = params[:output_biodatabase_group_name] ||
      "#{@test_fasta_file.biodatabase.name} vs #{@target_fasta_file.biodatabase.name}"

    @blast_result = new_blast_result("#{output_biodatabase_group_name} Blast Result")

    output_file_handle = Blast::Command.execute(:blastall, @blast_result, :test_file_path => @test_fasta_file.fasta.path,
      :target_file_path => @target_fasta_file.fasta.path,
      :evalue => evalue,
      :output_file_prefix => output_biodatabase_group_name.underscore)
    output_file_handle.open
    @blast_result.stopped_at = Time.now
    @blast_result.duration_in_seconds = (@blast_result.stopped_at - @blast_result.started_at)


    result_ff = Bio::FlatFile.open(output_file_handle)
    @matches = 0

    match_biodatabase_type = BiodatabaseType.find_by_name(BiodatabaseType::GENERATED_MATCH)
    BiodatabaseGroup.transaction do
      output_biodatabase_group  = ""
      if BiodatabaseGroup.exists? :name => output_biodatabase_group_name
        logger.error "output_biodatabase_group_name exists! #{output_biodatabase_group_name}"
        output_biodatabase_group  = BiodatabaseGroup.find_by_name(output_biodatabase_group_name)
      else
        logger.error "Creating output_biodatabase_group_name #{output_biodatabase_group_name}"
        output_biodatabase_group = BiodatabaseGroup.create!(:name => output_biodatabase_group_name,
          :project_id => @test_fasta_file.project_id,
          :parent => @test_fasta_file.biodatabase.biodatabase_group,
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
            new_db_name = "#{output_biodatabase_group.name } #{"%03d" % @number_of_fastas}"
            child_biodatabase = Biodatabase.new(:name => new_db_name,
              :biodatabase_group => output_biodatabase_group,
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
          FastaFile.generate_fasta(child_biodatabase)
        end
      end
    end
    @blast_result.output = output_file_handle
    @blast_result.save!
    logger.error( "Saved blast Results ")
    @blast_result
  end


end
