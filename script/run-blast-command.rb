
db_fasta_file = FastaFile.find_by_label("EST_Clade_A_3")
query_fasta_file = FastaFile.find_by_label("EST_Clade_A_5")

puts query_fasta_file.label
puts db_fasta_file.label

bc = BlastCommand.create(:db_fasta_file => db_fasta_file,
	:query_fasta_file => query_fasta_file,
	:evalue => 0.00001,
	:biodatabase_type => BiodatabaseType.find_by_name('GENERATED-MASTER'),
  :biodatabase_name => "NEW DB")

#bc = BlastCommand.create(:db_fasta_file => db_fasta_file,
#	:query_fasta_file => query_fasta_file , :evalue => 0.00001,:fasta_file_prefix => "prefix")
bc.run_command
bc.biodatabase.generate_fasta




