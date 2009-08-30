class Jobs::CloseConnections < Jobs::SqlQuery
  
  def initialize
    super('exec dses_etl.dbo.ddmc_close_connections', 'RestoreDestination')
  end
  
  def next_job_name
    "Jobs::RestoreDatabases"
  end
  
end