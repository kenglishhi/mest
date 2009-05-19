Biosequence.delete_all
BiodatabaseBiosequence.delete_all
Biodatabase.delete_all
db_fasta_file = FastaFile.find(:last)
query_fasta_file = db_fasta_file

bc = BlastCommand.create(:query_fasta_file => query_fasta_file,
	:evalue => 0.00001,
	:biodatabase_type => BiodatabaseType.find_by_name('UPLOADED-CLEANED'))
bc.run




