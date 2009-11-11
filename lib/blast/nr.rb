class Blast::Nr < Blast::Base

  protected

  def init_files_and_databases
    @test_database = Biodatabase.find(Biodatabase.find(@params[:test_biodatabase_id]) )
    @test_fasta_file.overwrite_fasta
    if @test_fasta_file.nil? 
      raise "Target or Test Fasta File does not exist"
    end
  end

  def do_run
    init_files_and_databases
#### blastall -p blastn -i fun.fasta -d /opt/local/var/data/nt
    evalue = get_evalue

    @blast_result = new_blast_result("#{output_biodatabase_group_name} Blast Result")

    output_file_handle = Blast::Command.execute(:blastall, @blast_result, :test_file_path => @test_fasta_file.fasta.path,
      :target_file_path => @target_fasta_file.fasta.path,
      :evalue => evalue,
      :output_file_prefix => output_biodatabase_group_name.underscore)
    output_file_handle.open
    @blast_result.stopped_at = Time.now
    @blast_result.duration_in_seconds = (@blast_result.stopped_at - @blast_result.started_at)
    @blast_result.output = output_file_handle
    @blast_result.save!
    logger.error( "Saved blast Results ")
    @blast_result
  end

end
