require 'pp'
class Jobs::AbstractJob
  
  attr_accessor :user_id
  attr_accessor :project_id
  attr_accessor :job_name
  attr_accessor :params
  def initialize(n, p  = {} )
    @job_name = n
    @params = p
  end
  def perform
    user_data = {:user_id => user_id, :project_id => project_id}
    params.merge!(user_data)
    puts "perform = params = #{params.inspect}"
    puts "perform = user_data =  #{user_data.inspect}  "
    do_perform
  end
  
  include Jobs::Chainable
  include Jobs::Loggable
  
  protected
  
  def do_perform
    raise "subclasses must implement"
  end
  
end
