Factory.define :job_log do |j|
  j.job_name 'Extract Sequences EST_Clade_A.fastaSequences'
  j.job_class_name  'Jobs::ExtractSequences'
  j.started_at '2009-10-10 04:34:30'
  j.stopped_at '2009-10-10 04:34:30'
end


Factory.define :blast_result do |br|
  br.name 'My New Blast'
  br.duration_in_seconds  1.2
  br.started_at '2009-10-10 04:37:30'
  br.stopped_at '2009-10-10 04:37:30'
  br.command 'blastall -p blastn -i /home/kenglish/NetBeansProjects/biococonutisland/public/system/fastas/2/original/EST_Clade_C.fasta -d /home/kenglish/NetBeansProjects/biococonutisland/public/system/fastas/2/original/EST_Clade_C.fasta -e 10e-25 -b 20 -v 20 -o /tmp/EST_Clade_C-Cleaned_Blast_Result.txt20091023-12679-1nec623-0 - blastall -p blastn -i /home/kenglish/NetBeansProjects/biococonutisland/public/system/fastas/4/original/EST_Clade_A_1.fasta -d /home/kenglish/NetBeansProjects/biococonutisland/public/system/fastas/4/original/EST_Clade_A_1.fasta -e 10e-25 -b 20 -v 20 -o /tmp/EST_Clade_A_1-Cleaned_Blast_Result.txt20091017-7952-xjib8f-0'
end

