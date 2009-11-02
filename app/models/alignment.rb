class Alignment < ActiveRecord::Base
  has_attached_file :aln
  belongs_to :fasta_file
end
