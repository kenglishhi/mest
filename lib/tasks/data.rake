namespace :data do

  desc "Load seed data"
  task :seed  => :environment  do
    puts "Load seed data --- HERE"
    User.destroy_all 
    User.create do |u|
      u.email = 'kenglish@gmail.com' 
      u.password =  'kevin123'
      u.password_confirmation =  'kevin123'
    end
  end
end

namespace :db do

  desc "Give birth to the system (without going into labor)."
  task :rebirth => ["db:drop", "db:create", "db:migrate", "data:seed"]

end
