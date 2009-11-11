class Jobs::Clustalw < Jobs::AbstractJob
  def param_keys
    [:biodatabase_id]
  end

  def do_perform

    param_keys.each do | required_param_key |
      raise "Error #{required_param_key} can not be blank!" if params[required_param_key].blank?
    end

    puts "------------"
    puts "  Calling clustalw #{params.inspect}  "
    puts "------------"
    biodatabase = Biodatabase.find(params[:biodatabase_id])
    FastaFile.generate_fasta(biodatabase) unless biodatabase.fasta_file
    biodatabase.fasta_file.generate_alignment
    puts " alignemnt_exists:    #{biodatabase.fasta_file.alignemnt_exists?}"
    puts " alignment_file_path: #{biodatabase.fasta_file.alignment_file_path}"
    puts " alignment_file_url:  #{biodatabase.fasta_file.alignment_file_url}"
    puts "------------"
    puts "  Finished clustalw "
    puts "--------------------------"
    true

  end
end

