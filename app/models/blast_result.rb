class BlastResult < ActiveRecord::Base
  has_attached_file :output,
    :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_output_file_name",
    :url => "/system/:attachment/:id/:style/:normalized_output_file_name"


  Paperclip.interpolates :normalized_output_file_name do |attachment, style|
    attachment.instance.normalized_output_file_name
  end

  def normalized_output_file_name
    "#{self.id}-blast-result.txt"
  end

end
