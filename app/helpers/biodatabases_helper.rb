module BiodatabasesHelper

#  def biodatabase_type_column(record)
#   if record.biodatabase_type.name == "UPLOADED-RAW"
#    record.biodatabase_type.name + "  "  +
#			link_to("Clean the File", new_tools_blast_cleaner_path(:biodatabase_id => record.id))
#   else
#    record.biodatabase_type.name
#   end
#  end

  def blast_actions_column(record)
   links =[] 
   links << link_to("Blast", new_tools_blast_create_db_path(:test_biodatabase_id => record.id))
   if record.biodatabase_type.name == BiodatabaseType::UPLOADED_RAW &&
      !record.biodatabase_links.any? {|b| b.biodatabase_link_type == BiodatabaseLinkType.cleaned}
     links << link_to("Clean", new_tools_blast_cleaner_path(:biodatabase_id => record.id))
   end

   links.join("&nbsp;&nbsp;")
  end
	def number_of_sequences_column(record)
    record.biosequences.count
	end

	def fasta_file_column(record)
   if record.fasta_file
  	 link_to record.fasta_file.fasta_file_name, record.fasta_file.fasta.url if record.fasta_file
	 else
  	 "Generate"
   end
	end


end
