module FastaFilesHelper
  def biodatabase_extract_column(record)
    if record.is_generated
      "Generated"
    elsif record.biodatabase
      "Extracted"
    else
      render  :partial => "/fasta_files/extract_sequences", :locals => {:record => record}
    end
  end
  def fasta_file_name_column(record)
    link_to record.fasta_file_name, record.fasta.url, :target => "_blank"
  end

  def fasta_file_size_column(record)
    return "#{record.fasta_file_size}" if record.fasta_file_size < 1024
    file_size = record.fasta_file_size * 1.0
    unit = "B"
    units = ["GB","MB","KB"]
    while file_size >= 1024.0
      file_size = (file_size) / 1024
      unit=units.pop
    end
    "#{sprintf("%.#{2}f", file_size)} #{unit}"
  end

end
