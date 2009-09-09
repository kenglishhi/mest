require 'pp'
class Jobs::AbstractJob
  
  attr_accessor :user
  attr_accessor :job_name
  attr_accessor :params
  def initialize(n, p  = {} )
    @job_name = n
    @params = p
  end
  def perform
    puts "Running #{@job_name} with :"
    pp params
    do_perform
  end
  
  include Jobs::Chainable
  include Jobs::Loggable
  
  protected
  
  def do_perform
    raise "subclasses must implement"
  end
  
end
