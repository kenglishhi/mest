class Jobs::BlastNrNt < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id, :evalue, :identity, :score]
  end

  def do_perform
    [ :biodatabase_id,:program,:ncbi_database].each do | required_param_key |
      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end

    if Job.exist?(job_id) 
      job = Job.find(job_id)
      job.estimated_completion_date = DateTime.now + 600
      job.save

    end
    biodatabase = Biodatabase.find(params[:biodatabase_id])
    if biodatabase.biodatabase_type == BiodatabaseType.database_group
      biodatabase.children.each do | child_db |
        unless child_db.biodatabase_type == BiodatabaseType.database_group
          blast_command = Blast::NrNt.new( params.merge({:biodatabase_id => child_db.id})  )
          blast_command.run
        end
      end
    else
      blast_command = Blast::NrNt.new( params )
      blast_command.run
    end
  end

end

