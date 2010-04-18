namespace :data do

  desc "Load seed data"
  task :seed  => :environment  do
    User.destroy_all 
    puts "Loading seed data.... "

    user = User.create do |u|
      u.email = 'admin@example.com' 
      u.first_name = 'Example' 
      u.last_name = 'Admin' 
      u.title = '' 
      u.password =  'admin123'
      u.password_confirmation =  'admin123'
    end
  end
end

namespace :db do

  desc "Give birth to the system (without going into labor)."
  task :rebirth => ["db:drop", "db:create", "db:migrate", "data:seed"]

end
