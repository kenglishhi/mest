class Jobs::AirForceMergeToFact < Jobs::SqlQuery
  
  def initialize
    super('exec dses_etl.dbo.populate_air_force_mishaps')
  end
  
  def next_job_name
    "Jobs::RebuildAggregates"
  end
  
end