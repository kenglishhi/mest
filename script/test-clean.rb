fasta_file_id = FastaFile.first.id

job = Jobs::CleanFileWithBlast.new("Clean Fasta",
{
  :fasta_file_id => fasta_file_id ,
  :evalue  => '0.001'
})

user = User.first
job.do_perform
#Job.create(:handler => do_nada, :job_name => 'do_nada 123',:user => User.first)


