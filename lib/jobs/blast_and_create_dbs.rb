class Jobs::BlastAndCreateDbs< Jobs::AbstractJob
  def param_keys
    [:test_biodatabase_id, :target_biodatabase_id, :evalue, :identity,
      :score, :output_biodatabase_group_name]
  end

  def do_perform
    [ :test_biodatabase_id, :target_biodatabase_id].each do | required_param_key |
       raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end
    blast_command = Blast::CreateDbs.new(params)
    blast_command.run
    true
  end

end
