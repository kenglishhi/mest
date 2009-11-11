class Jobs::DeleteDatabase < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id]
  end

  def do_perform

    param_keys.each do | required_param_key |
      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end

    biodatabase = Biodatabase.find(params[:biodatabase_id])
    biodatabase.destroy
    true

  end
end

