module  BioUtils

  def blastn_2_files(fasta_query_file, db_file,options={:evalue => 25})
    cmd_line_args = ""
#    if options[:evalue]
#      cmd_line_args = " -e #{options[:evalue]}"
#    end
    
    factory = Bio::Blast.local('blastn', fasta_query_file,cmd_line_args )
    ff = Bio::FlatFile.open(Bio::FastaFormat, db_file )

    ff.each do |entry|
#      puts "Searching..." + entry.definition
      report = factory.query(entry)
      fasta_data = ""
      unless report.hits.empty?
        fasta_data << Bio::Sequence::NA.new(entry.seq).to_fasta(entry.definition)
      end
      report.each do |hit|
        hit.each do |hsp|
          if hit.evalue < 0.0001
            s = Bio::Sequence::NA.new(hsp.hseq)
            fasta_data << Bio::Sequence::NA.new(entry.seq).to_fasta
          else
            puts "evalue too big #{hit.evalue}"
          end
        end
      end
      unless fasta_data.empty?
        puts " FASTA DATA #{ fasta_data} "
        new_file = "#{RAILS_ROOT}/tmp/#{entry.definition}.fasta"
        puts "#new_file = #{new_file}  "
        
        File.open(new_file, 'w') do |f2|  
          f2.puts fasta_data 
        end   
        f= File.new(new_file)
        ff = FastaFile.new
        ff.fasta =  f
        ff.save

      end
    end
  end
  private 
end

