module BiosequencesHelper
  def entire_seq_column(record)
    '<font face="Courier New, Courier, mono">' + wrap_text(record.seq)  + "</font>"
  end
  def wrap_text(txt, col = 50)
    txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/,
      "\\1\\3<br />\n")
  end
	def type_action_column(record)

	end
end
