class Jobs::CleanFileWithBlast < Jobs::AbstractJob
  def param_keys
    [:fasta_file_id, :biodatabase_id, :evalue, :identity,  :score]
  end

  def do_perform
    blast_command = BlastCommand.new
    blast_command.test_fasta_file = FastaFile.find(params[:fasta_file_id] )

    default_new_biodatabase_name =  blast_command.test_fasta_file.label + "-Cleaned"
    new_name = params[:new_biodatabase_name].blank? ? default_new_biodatabase_name :  params[:new_biodatabase_name]

    puts "New database name = #{new_name} "

    biodatabase = Biodatabase.new(:biodatabase_type => BiodatabaseType.find_by_name("UPLOADED-CLEANED"),
      :name => new_name,
      :user_id => blast_command.test_fasta_file.user_id )
    blast_command.output_biodatabase  = biodatabase 
    puts "Calling run_clean"
    puts "------------"
    blast_command.run_clean
    puts "------------"
    puts "FINISHED run_clean"
    puts "------------"
    true

  end
end

