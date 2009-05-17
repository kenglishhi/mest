module BiodatabasesHelper
  def type_action_column(record)
   if record.biodatabase_type.name == "Raw"
    link_to "Clean the File", :action => "clean", :id =>  record.id
   else
    "Clean"
   end
  end


end
