class Blast::NtAppend < Blast::Base
  DEFAULT_NUMBER_OF_SEQUENCES_TO_SAVE = 10
  protected

  def init_files_and_databases
    @biodatabase = Biodatabase.find(Biodatabase.find(@params[:biodatabase_id]) )

    if @biodatabase.fasta_file
      @biodatabase.fasta_file.overwrite_fasta
    else
      FastaFile.generate_fasta(@biodatabase)
    end
    @fasta_file = @biodatabase.fasta_file
  end

  def do_run
    init_files_and_databases
    #### blastall -p blastn -i fun.fasta -d /opt/local/var/data/nt
    evalue = get_evalue

    @blast_result = new_blast_result("#{@biodatabase.name}-NT Blast Result")
    number_of_sequences_to_save = params[:number_of_sequences_to_save].blank? ?
      DEFAULT_NUMBER_OF_SEQUENCES_TO_SAVE : params[:number_of_sequences_to_save].to_i

    output_file_handle = Blast::Command.execute(:blastall, @blast_result,
      :test_file_path => @fasta_file.fasta.path,
      :evalue => evalue,
      :number_of_hits_per_query => number_of_sequences_to_save,
      :nt => true,
      :output_file_prefix => "#{@biodatabase.name}-NR}")
    output_file_handle.open
    @blast_result.stopped_at = Time.now
    @blast_result.duration_in_seconds = (@blast_result.stopped_at - @blast_result.started_at)
    result_ff = Bio::FlatFile.open(output_file_handle)
    match_count = 0
    logger.error("kenglish] number_of_sequences_to_save = #{number_of_sequences_to_save }" )
    result_ff.each do |report|
      report.each do |hit|
        bioseq = Biosequence.find_by_name( hit.target_def)
        unless bioseq
          begin
            bioseq = Biosequence.new(:name => hit.target_def,
              :seq => hit.target_seq.upcase,
              :alphabet => 'dna',
              :nr_sequence_flag => true,
              :length => hit.target_len,
              :original_name => hit.target_def)
            bioseq.save!
          rescue ActiveRecord::RecordInvalid =>  e
            suffix = "_#{@biodatabase.id}_#{@biodatabase.biosequences.size}"
            if ((bioseq.name.size + suffix.size) > 255)
              bioseq.name = bioseq.name[0..(255 - suffix.size - 1)] + suffix
            else
              bioseq.name += suffix
            end
            bioseq.save!
          end
        end
        puts bioseq.name
        @biodatabase.biosequences << bioseq unless @biodatabase.biosequences.include?(bioseq)
        match_count += 1
        break if (match_count >=number_of_sequences_to_save )
      end
      break if (match_count >=number_of_sequences_to_save )
    end
    @biodatabase.fasta_file.overwrite_fasta
    @blast_result.output = output_file_handle
    @blast_result.save!
    @blast_result
  end

  private

end
