# To change this template, choose Tools | Templates
# and open the template in the editor.

module DurationDisplay
  def duration_format(seconds)
    duration_sec = seconds.to_i
    [ duration_sec / 3600,  (duration_sec / 60) % 60, duration_sec % 60 ].map{ |t| t.to_s.rjust(2, '0') }.join(':')
  end
    
end
