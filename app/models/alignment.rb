class Alignment < ActiveRecord::Base
  has_attached_file :aln
  belongs_to :fasta_file


  def self.generate_alignment(target_fasta_file)
    clustalw = Bio::ClustalW.new
    clustalw.query_by_filename(target_fasta_file.fasta.path)
    puts clustalw.output
  end

end
