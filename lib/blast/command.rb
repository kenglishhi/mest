class Blast::Command

  #############################
  #
  # Options:
  #   Blast::Command.execute(:test_file_path => '/path/to/test.fasta',
  #     :target_file_path => '/path/to/target.fasta',
  #     :evalue => '0.0001',
  #     :output_file_prefix => 'Output1')
  #
  #############################

  cattr_accessor :ncbi_database_directory
  ########################################3
  #  nr.*tar.gz:	Non-redundant protein sequence database with entries from
  #     GenPept, Swissprot, PIR, PDF, PDB, and NCBI RefSeq.
  #     NOTE that nr does NOT contain sequences found in pataa and env_nr databases.
  #
  #  nt.*tar.gz:	Nucleotide sequence database, with entries from all traditional
  #    divisions of GenBank, EMBL, and DDBJ excluding bulk divisions (gss, sts,
  #    pat, est, and htg) as well as wgs entries. Minimally non-redundant.
  #
  ########################################3


  PROGRAMS = ['blastp', 'blastn', 'blastx', 'psitblastn', 'tblastn', 'tblastx'] 

  def self.execute(program, blast_result, params)
    if program.to_sym == :blastall
      self.execute_blastall(blast_result,params)
    elsif program.to_sym == :blastcl3
      self.execute_blastcl3(blast_result,params)
    else
      raise "Invalid program '#{program} called for Blast::Command.execute"
    end
  end

  def self.execute_blastall(blast_result, params)
#    pp params
    required_params = [:test_file_path, :evalue, :output_file_prefix]
    required_params.each do | required_option|
      raise "Blast Error: Option #{required_option} is blank" if params[required_option].blank?
    end
    if params[:evalue]  !~ /^10e-/
      params[:evalue] = "10e-#{params[:evalue]}"
    end
    cli ={}
    program  = PROGRAMS.include?(params[:program]) ? params[:program] : 'blastn'
    cli['-p'] = program
    cli['-e'] = params[:evalue]
    cli['-b'] =  params[:number_of_hits_per_query].blank? ? 50 :  params[:number_of_hits_per_query]
    puts "nr_nt_flag = #{params[:nr_nt_flag] }"
    puts "ncbi_database = #{params[:ncbi_database] }"
    cli['-d'] = params[:nr_nt_flag] ? "#{self.ncbi_database_directory}/#{params[:ncbi_database]}" : params[:target_file_path]
    cli['-i'] = params[:test_file_path]
    options =  cli.to_a.join(' ')

    command = " blastall #{options} "
    puts command
    blast_result.command = command if blast_result
    logger.info("[kenglish] blast command = #{command}")
    output_file_handle = Tempfile.new("#{params[:output_file_prefix].gsub(/ /,"_")}_Blast_Result.txt")

    output_file_handle.close(false)
    command <<  "-o  #{output_file_handle.path} "
    system(*command)
    output_file_handle.close
    output_file_handle

  end
end

