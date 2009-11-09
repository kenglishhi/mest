module AlignmentsHelper
  def aln_file_name_column(record)
   link_to record.aln, record.aln.url, :target => "_blank"
 end
end
