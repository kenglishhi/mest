module FastaFilesHelper
 def biodatabase_extract_column(record)
   if record.is_generated
		 "Generated"
   elsif record.biodatabase
     "Extracted"
   else
      render  :partial => "/fasta_files/biodatabase_extract_link", :locals => {:record => record}
   end
 end
 def fasta_file_name_column(record)
	 link_to record.fasta_file_name, record.fasta.url
 end
end
