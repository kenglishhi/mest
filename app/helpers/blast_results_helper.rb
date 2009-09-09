module BlastResultsHelper
 def output_file_name_column(record)
	 link_to record.output, record.output.url
 end
end
