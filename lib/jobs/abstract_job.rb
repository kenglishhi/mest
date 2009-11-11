require 'pp'
class Jobs::AbstractJob
  
  attr_accessor :user_id
  attr_accessor :project_id
  attr_accessor :job_name
  attr_accessor :params
  def initialize(n, p  = {} )
    @job_name = n
    @params = p
    @user_id = p[:user_id] if p[:user_id]
    @project_id = p[:project_id] if p[:project_id]
  end
  def perform
    user_data = {:user_id => user_id, :project_id => project_id}
    params.merge!(user_data)

    puts "------------"
    puts "Calling #{self.class}( params = #{params.inspect})  "
    puts "------------"

    do_perform

    puts "------------"
    puts "FINISHED #{self.class}"
    puts "--------------------------"
  end
  
  include Jobs::Chainable
  include Jobs::Loggable
  
  protected
  
  def do_perform
    raise "subclasses must implement"
  end
  
end
