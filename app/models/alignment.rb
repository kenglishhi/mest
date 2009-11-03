class Alignment < ActiveRecord::Base
  has_attached_file :aln
  belongs_to :fasta_file
  belongs_to :user


  def self.generate_alignment(target_fasta_file,user=nil)
    clustalw = Bio::ClustalW.new
    clustalw.query_by_filename(target_fasta_file.fasta.path)
    puts clustalw.output
    create(:label => 'Alignment xxxx', :user => user)
  end

end
