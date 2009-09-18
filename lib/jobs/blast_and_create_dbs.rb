class Jobs::BlastAndCreateDbs< Jobs::AbstractJob

  def do_perform
    [:user_id, :test_fasta_file_id, :target_fasta_file_id].each do | required_param_key |
       raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end
    blast_command = Blast::CreateDbs.new(params)
    puts "Calling Blast::CreateDbs( params = #{params.inspect})  "
    puts "------------"
    blast_command.run
    puts "------------"
    puts "FINISHED Blast::CreateDbs"
    puts "--------------------------"
    true
  end

end
