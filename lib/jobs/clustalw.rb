class Jobs::Clustalw < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id]
  end

  def do_perform

    #    param_keys.each do | required_param_key |
    #      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    #    end
    if !params[:biodatabase_id].blank?
      biodatabase = Biodatabase.find(params[:biodatabase_id])
      FastaFile.generate_fasta(biodatabase) unless biodatabase.fasta_file
      biodatabase.fasta_file.generate_alignment
    elsif !params[:biodatabase_group_id].blank?
      biodatabase_group = BiodatabaseGroup.find(params[:biodatabase_group_id] )
      biodatabase_group.biodatabases.each do | biodatabase |
        FastaFile.generate_fasta(biodatabase) unless biodatabase.fasta_file
        biodatabase.fasta_file.generate_alignment
      end
    end
  end
end

