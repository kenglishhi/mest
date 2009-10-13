class BlastResult < ActiveRecord::Base
  has_attached_file :output,
    :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_output_file_name",
    :url => "/system/:attachment/:id/:style/:normalized_output_file_name"

  include ExtJS::Model
  extjs_fields :id, :name, :command,:output_file_name_display,:output_file_url, :started_at, :stopped_at

  @@per_page = 10
  Paperclip.interpolates :normalized_output_file_name do |attachment, style|
    attachment.instance.normalized_output_file_name
  end

  def normalized_output_file_name
    "#{self.id}-blast-result.txt"
  end
  def output_file_name_display
    File.basename(self.output.to_s)
  end
  def output_file_url
    self.output.url
  end
end
