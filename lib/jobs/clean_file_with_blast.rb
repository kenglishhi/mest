class Jobs::CleanFileWithBlast < Jobs::AbstractJob
  def param_keys
    [:fasta_file_id, :biodatabase_id, :evalue, :identity,  :score]
  end
  def do_perform
    blast_command = BlastCommand.new
    blast_command.test_fasta_file = FastaFile.find(params[:fasta_file_id] )
    blast_command.biodatabase_type  = BiodatabaseType.find_by_name("UPLOADED-CLEANED")
    blast_command.biodatabase_name  = blast_command.test_fasta_file.label + "-Cleaned"


    blast_command.run_clean
  end
end

