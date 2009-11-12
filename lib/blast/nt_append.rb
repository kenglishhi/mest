class Blast::NtAppend < Blast::Base

  protected

  def init_files_and_databases
    @biodatabase = Biodatabase.find(Biodatabase.find(@params[:biodatabase_id]) )

    if @biodatabase.fasta_file
      @biodatabase.fasta_file.overwrite_fasta
    else
      FastaFile.generate_fasta(@biodatabase)
    end
    @fasta_file = @test_database.fasta_file
  end

  def do_run
    init_files_and_databases
    #### blastall -p blastn -i fun.fasta -d /opt/local/var/data/nt
    evalue = get_evalue

    @blast_result = new_blast_result("#{@biodatabase.name}-NT Blast Result")

    output_file_handle = Blast::Command.execute(:blastall, @blast_result,
      :test_file_path => @fasta_file.fasta.path,
      :evalue => evalue,
      :nr => true,
      :output_file_prefix => "#{@diodatabase.name}-NR}")
    output_file_handle.open
    @blast_result.stopped_at = Time.now
    @blast_result.duration_in_seconds = (@blast_result.stopped_at - @blast_result.started_at)
    @blast_result.output = output_file_handle
    @blast_result.save!
    logger.error("Saved blast Results ")
    @blast_result
  end

  private

end
