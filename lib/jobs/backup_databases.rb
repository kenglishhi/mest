class Jobs::BackupDatabases < Jobs::SqlQuery
  
  def initialize
    super('exec dses_etl.dbo.ddmc_backup', "BackupSource")
  end
  
  def next_job_name
    "Jobs::CopyBackups"
  end
  
end