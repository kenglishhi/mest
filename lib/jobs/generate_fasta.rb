class Jobs::GenerateFasta < Jobs::AbstractJob
  def do_perform
    if params[:biodatabase_id].nil?
      raise "Database Id not provided"
      return
    end

    FastaFile.generate_fasta(Biodatabase.find( params[:biodatabase_id]) )
    true
  end
end

