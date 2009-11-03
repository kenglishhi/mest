class Alignment < ActiveRecord::Base
  has_attached_file :aln
  belongs_to :fasta_file
  belongs_to :user


  def self.generate_alignment(target_fasta_file,user=nil)
    output_file_handle = Tempfile.new("#{target_fasta_file.label}_align.aln")
    command = " clustalw -infile=#{target_fasta_file.fasta.path} -outfile=#{output_file_handle.path} "
    puts "command = #{command} "
    system(*command)
    create(:label => 'Alignment xxxx',
      :user => user,
      :aln => output_file_handle,
      :fasta_file => target_fasta_file)
  end
  def report
    if aln
      Bio::ClustalW::Report.new(File.read(aln.path ))
    end
  end
end
