class Jobs::GenerateFasta < Jobs::AbstractJob
  def do_perform
    if params[:biodatabase_id].nil?
      raise "Database Id not provided"
      return
    end

    puts "------------"
    puts "  Running Jobs::GenerateFasta #{params.inspect}  "
    puts "------------"
    FastaFile.generate_fasta(Biodatabase.find( params[:biodatabase_id]) )
    puts "------------"
    puts "  Finished Jobs::GenerateFasta "
    puts "--------------------------"
    true
  end
end

