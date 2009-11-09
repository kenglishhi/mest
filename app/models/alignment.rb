class Alignment < ActiveRecord::Base
  has_attached_file :aln
  belongs_to :biodatabase
  belongs_to :user


  def self.generate_alignment(biodatabase,user=nil)
    target_fasta_file = biodatabase.fasta_file

    output_file_handle = Tempfile.new("#{target_fasta_file.label}_align.aln")
    command = " clustalw -infile=#{target_fasta_file.fasta.path} -outfile=#{output_file_handle.path} "
    system(*command)
    create(:label => 'Alignment xxxx',
      :user => user,
      :aln => output_file_handle,
      :biodatabase => biodatabase)
  end
  def report
    if aln
      Bio::ClustalW::Report.new(File.read(aln.path ))
    end
  end
end
