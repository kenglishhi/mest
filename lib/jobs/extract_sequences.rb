class Jobs::ExtractSequences < Jobs::AbstractJob
  def do_perform
    if params[:fasta_file_id].nil?
      raise "Fasta File not provided"
      return
    end

    puts "------------"
    puts "  Running Jobs::ExtractSequences #{params.inspect}  "
    puts "------------"
    fasta_file = FastaFile.find( params[:fasta_file_id] )
    fasta_file.extract_sequences
    puts "------------"
    puts "  Finished Jobs::ExtractSequences "
    puts "--------------------------
    true

  end
end

