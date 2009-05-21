class Biodatabase < ActiveRecord::Base
	acts_as_tree
  belongs_to :biodatabase_type
  belongs_to :fasta_file
	has_many :biodatabase_biosequences, :dependent => :destroy
  has_many :biosequences, :through => :biodatabase_biosequences
  validates_presence_of :name
  validates_presence_of :biodatabase_type_id

	def generate_fasta
		if fasta_file_id.nil?
			if biodatabase_type.name == "GENERATED-MASTER"
				children.each do | child |
					child.generate_fasta
				end
			elsif 	["UPLOADED-CLEANED","GENERATED-MATCH" ].include? biodatabase_type.name
				filename =  "#{name}.fasta"
				fasta_file_handle = File.new(filename,"w")
				biosequences.each do | seq |
					fasta_file_handle.puts(seq.to_fasta)
				end
				fasta_file_handle.close
				puts "generating fasta"

				fasta_file_handle = File.new(filename,"r")
				self.fasta_file = FastaFile.new
				self.fasta_file.fasta = fasta_file_handle
				self.fasta_file.is_generated = true
				self.fasta_file.save
				puts "new id #{self.fasta_file.errors.full_messages.to_sentence} "
				save
			else
				logger.error("not generating fasta")
			end
		end
	end

end
