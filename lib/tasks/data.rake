namespace :data do

  desc "Load seed data"
  task :seed  => :environment  do
    User.destroy_all 
    puts "Loading seed data.... "

    admin_user = User.create do |u|
      u.email = 'admin@example.com' 
      u.first_name = 'Example' 
      u.last_name = 'Admin' 
      u.title = '' 
      u.password =  'admin123'
      u.password_confirmation =  'admin123'
    end
    Lockdown::System.make_user_administrator(admin_user)
    reg_user = User.create do |u|
      u.email = 'mest.hawaii@gmail.com'
      u.first_name = 'Demo'
      u.last_name = 'Hawaii'
      u.title = ''
      u.password =  'demo'
      u.password_confirmation =  'demo'
    end

  end
end

namespace :db do

  desc "Give birth to the system (without going into labor)."
  task :rebirth => ["db:drop", "db:create", "db:migrate", "data:seed"]

end
