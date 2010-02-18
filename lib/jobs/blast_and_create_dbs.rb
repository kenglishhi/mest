class Jobs::BlastAndCreateDbs< Jobs::AbstractJob
  def param_keys
    [:test_biodatabase_id, :target_biodatabase_ids, :evalue, :identity,
      :score, :output_parent_biodatabase_name]
  end

  def do_perform
    [ :test_biodatabase_id, :target_biodatabase_ids].each do | required_param_key |
      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end
    blast_command = Blast::CreateDbs.new(params)
    blast_command.run
    true
  end


  protected

  def update_job_estimated_completion_time
    seconds_per_operation = 0.02
    biodatabase = Biodatabase.find(params[:test_biodatabase_id])
    seconds_to_complete = seconds_per_operation * biodatabase.biosequences.size
    job = Job.find(job_id)
    job.estimated_completion_date = DateTime.now.advance(:seconds => seconds_to_complete)
    self.estimated_completion_date = estimated_completion_date
    job.save
  end


end
