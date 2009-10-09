require 'rubygems'
require 'curb'

url = 'http://gp202.ics.hawaii.edu/user_session/new'
100.times do | i | 
c = Curl::Easy.new(url) do |curl|
  curl.headers["User-Agent"] = "myapp-0.0"
  curl.verbose = true
end

c.perform

end
