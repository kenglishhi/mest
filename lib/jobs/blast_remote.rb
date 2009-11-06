class Jobs::BlastRemote < Jobs::AbstractJob
  def param_keys
    [:test_biodatabase_id, :evalue, :identity,
      :score, :output_biodatabase_group_name]
  end

  def do_perform
    [ :test_biodatabase_id, :user_id , :project_id].each do | required_param_key |
       raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end
    blast_command = Blast::Remote.new(params)
    puts "Calling Blast::Remote( params = #{params.inspect})  "
    puts "------------"
    blast_command.run

    puts "------------"
    puts "FINISHED Blast::CreateDbs"
    puts "--------------------------"
    true
  end

end

