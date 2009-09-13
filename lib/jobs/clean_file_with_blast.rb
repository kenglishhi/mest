class Jobs::CleanFileWithBlast < Jobs::AbstractJob
  def param_keys
    [:fasta_file_id, :biodatabase_id, :evalue, :identity,  :score]
  end

  def do_perform
    blast_command = BlastCommand.new(params)
    puts "Calling run_clean"
    puts "------------"
    blast_command.run_clean
    puts "------------"
    puts "FINISHED run_clean"
    puts "--------------------------"
    true

  end
end

