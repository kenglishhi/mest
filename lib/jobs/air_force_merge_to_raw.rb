class Jobs::AirForceMergeToRaw < Jobs::XmlLoad

  def initialize
    super("Sources::AirForce::Afsas", "Jobs::AirForceSync")
  end
  
  def next_job_name
    "Jobs::AirForceMergeToFact"
  end

end
