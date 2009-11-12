class Jobs::BlastNtAppend < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id, :evalue, :identity, :score]
  end

  def do_perform
    blast_command = Blast::NtAppend.new(params)
    blast_command.run
  end
end

