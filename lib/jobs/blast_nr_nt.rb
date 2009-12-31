class Jobs::BlastNrNt < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id, :evalue, :identity, :score]
  end

  def do_perform
    [ :biodatabase_id,:program,:ncbi_database].each do | required_param_key |
      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end

    biodatabase = Biodatabase.find(params[:biodatabase_id])
    if biodatabase.biodatabase_type == BiodatabaseType.database_group
      biodatabase.children.each do | biodatabase |
        blast_command = Blast::NrNt.new( params.merge({:biodatabase_id => biodatabase.id})  )
        blast_command.run
      end
    else
      blast_command = Blast::NrNt.new( params )
      blast_command.run
    end
  end

end

