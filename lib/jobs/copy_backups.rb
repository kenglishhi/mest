class Jobs::CopyBackups < Jobs::SystemCommand
  
  def initialize
    super("copy C:\\Temp\\Litespeed\\raw_air_force_mishaps.bak z:\\ /Y",
           "copy C:\\Temp\\LiteSpeed\\dses_rollup.bak z:\\ /Y")
  end
  
  def next_job_name
    "Jobs::DisplayMaintenancePage"
  end
  
end