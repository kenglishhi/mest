class Jobs::XmlLoad < Jobs::AbstractJob

  attr_reader :package_name_prefix, :job_name

  # package_name_prefix - where to find the active record models?
  # job_name - how to filter for downloaded xml?
  def initialize(package_name_prefix, job_name)
    @package_name_prefix = package_name_prefix
    @job_name = job_name
  end

  def do_perform
    find_unprocessed_result_ids.each do |result_id|
      download_result = DownloadResult.find(result_id)
      DdmcXmlLoader.new(package_name_prefix, download_result.processed_xml).load
      download_result.update_attributes!(:processed_at => Time.now)
    end
  end
  
  private

  def find_unprocessed_result_ids
    DownloadResult.connection.select_values("SELECT id FROM download_results WHERE job_name = '#{job_name}' AND processed_at IS NULL")
  end

end
