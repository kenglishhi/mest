class Jobs::CleanDatabaseWithBlast < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id, :evalue, :identity,  :score]
  end

  def do_perform
    [ :biodatabase_id ].each do | required_param_key |
      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end

    if Job.exist?(self.job_id)
      job = Job.find(self.job_id)
      job.estimated_completion_date = DateTime.now + 600
      job.save
    end

    params.merge!(:blast_result_name => "#{job_name} Blast Results" ) 
    blast_command = Blast::CleanDb.new(params)
    blast_command.run
  end
end

