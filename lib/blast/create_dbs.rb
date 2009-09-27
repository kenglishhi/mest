class Blast::CreateDbs < Blast::Base

  protected

  def do_run
    evalue = params[:evalue].blank? ?  0.000001 : params[:evalue]
    test_fasta_file = FastaFile.find(params[:test_fasta_file_id])
    target_fasta_file = FastaFile.find(params[:target_fasta_file_id])
    target_fasta_file.formatdb

    test_fasta_file.extract_sequences if !test_fasta_file.is_generated &&
      test_fasta_file.biodatabase.nil?
    target_fasta_file.extract_sequences if !target_fasta_file.is_generated &&
      target_fasta_file.biodatabase.nil?

    output_biodatabase_group_name = params[:output_biodatabase_group_name] ||
      "#{test_fasta_file.biodatabase.name} vs #{target_fasta_file.biodatabase.name}"
    @blast_result = BlastResult.new(:name => "#{output_biodatabase_group_name} Blast Result",
      :started_at => Time.now
    )
    output_file_handle = Blast::Command.execute(:test_file_path => test_fasta_file.fasta.path,
      :target_file_path => target_fasta_file.fasta.path,
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
        puts "output_biodatabase_group_name exists! #{output_biodatabase_group_name}"
        output_biodatabase_group  = BiodatabaseGroup.find_by_name(output_biodatabase_group_name)
      else
        puts "Creating output_biodatabase_group_name #{output_biodatabase_group_name}"
        output_biodatabase_group = BiodatabaseGroup.create!(:name => output_biodatabase_group_name,
          :project_id => test_fasta_file.project_id,
          :user_id => params[:user_id])
      end

      @number_of_fastas = 0
      result_ff.each do |report|
        test_biosequence = Biosequence.find_by_name(report.query_def)
        
        first_flag = true
        child_biodatabase =nil
        report.each do |hit|

          if first_flag
            @number_of_fastas += 1
            new_db_name = "#{output_biodatabase_group.name } #{@number_of_fastas}"
            puts new_db_name
            child_biodatabase = Biodatabase.new(:name => new_db_name,
              :biodatabase_group => output_biodatabase_group,
              :biodatabase_type => match_biodatabase_type,
              :user_id => params[:user_id] )

            child_biodatabase.biosequences << test_biosequence
            first_flag = false
          end
          @matches += 1
          # puts "Hit target = #{hit.target_def}"
          target_biosequence = Biosequence.find_by_name(hit.target_def)

          # puts "hit == #{target_biosequence.nil?}"
          #  puts "hit == #{target_biosequence}"
          child_biodatabase.biosequences << target_biosequence
        end
        if child_biodatabase.nil? # no matches
           puts "No Matches"
        else
          child_biodatabase.save!
          child_biodatabase.generate_fasta
        end
      end
    end
    @blast_result.output= output_file_handle
    @blast_result.save!
    puts "Saved blast Results "
    @blast_result
  end


end