
blast = Jobs::BlastFasta.new
blast.job_config = {'config1' => 'value1',
               'config2' => 'value2',
               'config3' => 'value3',
               'config4' => 'value4',
               'config5' => 'value5'
}

Job.create(:handler => blast, :job_name => 'blast123') 

