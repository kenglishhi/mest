class Jobs::CleanFileWithBlast < Jobs::AbstractJob
  def do_perform
    blast_command = BlastCommand.new
    blast_command.test_fasta_file = FastaFile.find(params[:fasta_file_id] )

    run_clean
  end
end

