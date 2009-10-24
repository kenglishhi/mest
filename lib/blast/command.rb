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
    required_params = [:test_file_path,:target_file_path, :evalue, :output_file_prefix]
    required_params.each do | required_option|
      raise "Blast Error: Option #{required_option} is blank" if params[required_option].blank?
    end
    if params[:evalue]  !~ /^10e-/
      params[:evalue] = "10e-#{params[:evalue]}"
    end
    command = " blastall -p blastn -i #{params[:test_file_path]} -d #{params[:target_file_path] } -e #{params[:evalue]}  -b 20 -v 20 "
    blast_result.command = command if blast_result
    puts "[kenglish] blast command = #{command}"
    Delayed::Worker.logger.error("[kenglish] blast command = #{command}")
    output_file_handle = Tempfile.new("#{params[:output_file_prefix].gsub(/ /,"_")}_Blast_Result.txt")

    output_file_handle.close(false)
    command <<  "-o  #{output_file_handle.path} "
    system(*command)
    output_file_handle.close
    output_file_handle

  end
  def self.execute_blastcl3(blast_result, params)

  end
end

