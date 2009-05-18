module BiodatabasesHelper
  def type_action_column(record)
   if record.biodatabase_type.name == "Raw"
    link_to "Clean the File", :controller => 'blast', :action => "clean", :biodatabase_id =>  record.id
   else
    "Cleaned"
   end
  end
	def fasta_file_column(record)
   if record.fasta_file
  	 link_to record.fasta_file.fasta_file_name, record.fasta_file.fasta.url if record.fasta_file
	 else
  	 "Generate"
   end
	end


end
