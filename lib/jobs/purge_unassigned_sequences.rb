class Jobs::PurgeUnassignedSequences < Jobs::AbstractJob
  def do_perform
    Biosequence.purge_unassigned_sequences
  end
end

