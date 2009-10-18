class Jobs::CleanDatabaseWithBlast < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id, :evalue, :identity,  :score]
  end

  def do_perform

    [:user_id, :biodatabase_id].each do | required_param_key |
      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end
    params.merge!(:blast_result_name => "#{job_name} Blast Results" ) 
    blast_command = Blast::CleanDb.new(params)
    puts "Calling Blast::Clean( params = #{params.inspect})  "
    puts "------------"
    blast_command.run
    puts "------------"
    puts "Finished Blast::Clean"
    puts "--------------------------"
    true

  end
end

