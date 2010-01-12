class Jobs::Clustalw < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id]
  end

  def do_perform
    if !params[:biodatabase_id].blank?
      biodatabase = Biodatabase.find(params[:biodatabase_id])
      if biodatabase.biodatabase_type == BiodatabaseType.database_group
        biodatabase.children.each do | biodatabase |
          FastaFile.generate_fasta(biodatabase) #unless biodatabase.fasta_file
          biodatabase.fasta_file.generate_alignment
        end
      else
        FastaFile.generate_fasta(biodatabase) #unless biodatabase.fasta_file
        biodatabase.fasta_file.generate_alignment
      end
    end
  end
end

