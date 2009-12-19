class Jobs::BlastGroupNtAppend < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id, :evalue, :identity, :score]
  end

  def do_perform
    [ :biodatabase_id].each do | required_param_key |
      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end

    biodatabase = Biodatabase.find(params[:biodatabase_id ] )
    biodatabase.children.each do | bdb |
      blast_command = Blast::NtAppend.new params.merge({:biodatabase_id => bdb.id})
      blast_command.run
    end

#    BiodatabaseGroup.find(params[:biodatabase_group_id]).biodatabases.each do |bdb|
#      blast_command = Blast::NtAppend.new params.merge({:biodatabase_id => bdb.id})
#      blast_command.run
#    end
  end
end

