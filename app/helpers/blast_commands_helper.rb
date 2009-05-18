module BlastCommandsHelper
  def output_file_name_column(record)
     link_to record.output_file_name, record.output.url
  end
end
