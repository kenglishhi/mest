class Jobs::BlastNr < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id, :evalue, :identity,
      :score, :output_biodatabase_group_name]
  end

  def do_perform
    blast_command = Blast::Nr.new(params)
    blast_command.run
  end
end

