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
    Alignment.generate_alignment(biodatabase, User.find(params[:user_id]) )
    puts "------------"
    puts "  Finished biodatabse.destroy  "
    puts "--------------------------"
    true

  end
end

