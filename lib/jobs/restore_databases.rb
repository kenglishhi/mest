class Jobs::RestoreDatabases < Jobs::SqlQuery
  
  def initialize
    super('exec dses_etl.dbo.ddmc_restore', "RestoreDestination")
  end
  
  def next_job_name
    "Jobs::RemoveMaintenancePage"
  end
  
end