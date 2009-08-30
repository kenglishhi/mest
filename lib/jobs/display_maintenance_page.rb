class Jobs::DisplayMaintenancePage < Jobs::AbstractJob
  
  def do_perform
    
  end
  
  def next_job_name
    "Jobs::CloseConnections"
  end
  
end