module FastaFilesHelper
 def biodatabase_extract_column(record)
   if record.biodatabase
     "Extracted"
   else
      render  :partial => "/fasta_files/biodatabase_extract_link", :locals => {:record => record}
   end
 end

end
