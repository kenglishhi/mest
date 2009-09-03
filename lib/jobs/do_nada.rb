class Jobs::DoNada < Jobs::AbstractJob
  def do_perform
    puts "Hello World"
    puts params.inspect
    puts user.inspect
  end
end

