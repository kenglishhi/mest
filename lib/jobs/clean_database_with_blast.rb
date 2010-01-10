class Jobs::CleanDatabaseWithBlast < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id, :evalue, :identity,  :score]
  end

  def do_perform
    [ :biodatabase_id ].each do | required_param_key |
      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end

    params.merge!(:blast_result_name => "#{job_name} Blast Results" ) 
    blast_command = Blast::CleanDb.new(params)
    blast_command.run
  end
  protected
  def update_job_estimated_completion_time

    seconds_per_operation = 0.06
    biodatabase = Biodatabase.find(params[:biodatabase_id])
    seconds_to_complete = seconds_per_operation * biodatabase.biosequences.size
    job = Job.find(job_id)
    job.estimated_completion_date = DateTime.now.advance(:seconds => seconds_to_complete)
    self.estimated_completion_date = estimated_completion_date
    job.save
  end
end