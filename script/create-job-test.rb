
do_nada = Jobs::DoNada.new({
  'config1' => 'value1', 'config2' => 'value2',
  'config3' => 'value3',
  'config4' => 'value4',
  'config5' => 'value5'
})

user = User.first
Job.create(:handler => do_nada, :job_name => 'do_nada 123',:user => User.first)

