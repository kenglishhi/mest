class Jobs::BlastFasta < Jobs::AbstractJob

  attr_reader :config
  attr_accessor :delayed_job
  attr_accessor :job_config

  def initialize
  end

  def perform
    puts "Call Blast" 
    puts @job_config.inspect
    true
  end

end
