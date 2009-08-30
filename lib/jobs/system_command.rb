class Jobs::SystemCommand < Jobs::AbstractJob
  
  attr_reader :commands
  
  def initialize(*commands)
    @commands = commands
  end
  
  def do_perform
    commands.each do |command|
      completed = system(command)
      raise "command failed: #{command}" unless completed
    end
  end
  
end