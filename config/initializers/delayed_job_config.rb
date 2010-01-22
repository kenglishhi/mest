# To change this template, choose Tools | Templates
# and open the template in the editor.

Delayed::Job.destroy_failed_jobs = false

silence_warnings do
  Delayed::Job.const_set("MAX_ATTEMPTS", 0)
  Delayed::Job.const_set("MAX_RUN_TIME", 0)
end

