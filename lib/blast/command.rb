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

  def self.execute(options)

    required_options = [:test_file_path,:target_file_path, :evalue, :output_file_prefix]
    required_options.each do | required_option|
      raise "Blast Error: Option #{required_option} is blank" if options[required_option].blank?
    end

    command = " blastall -p blastn -i #{options[:test_file_path]} -d #{options[:target_file_path] } -e #{options[:evalue]}  -b 20 -v 20 "
    output_file_handle = Tempfile.new("#{options[:output_file_prefix].gsub(/ /,"_")}_Blast_Result.txt")
    output_file_handle.close(false)
    command <<  "-o  #{output_file_handle.path} "
    system(*command)
    output_file_handle.close
    output_file_handle
  end
end

