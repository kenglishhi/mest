class Jobs::RebuildAggregates < Jobs::SqlQuery
  
  def initialize
    super('exec dses_etl.dbo.populate_mishap_aggregates')
  end
  
  def next_job_name
    "Jobs::BackupDatabases"
  end
  
end
