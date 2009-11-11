class Jobs::RenameSequencesInDb < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id,:prefix]
  end

  def do_perform

    [:biodatabase_id,:prefix].each do | required_param_key |
       raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end

    @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    @biodatabase.rename_sequences(params[:prefix])

  end
end

