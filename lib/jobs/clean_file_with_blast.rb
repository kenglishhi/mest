class Jobs::CleanFileWithBlast < Jobs::AbstractJob
  def param_keys
    [:fasta_file_id, :biodatabase_id, :evalue, :identity,  :score]
  end

  def do_perform

    [ :fasta_file_id ].each do | required_param_key |
       raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end
    blast_command = Blast::Clean.new(params)
    puts "Calling Blast::Clean( params = #{params.inspect})  "
    puts "------------"
    blast_command.run
    puts "------------"
    puts "Finished Blast::Clean"
    puts "--------------------------"
    true

  end
end

