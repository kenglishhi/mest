namespace :data do

  desc "Load seed data"
  task :seed  => :environment  do
    User.destroy_all 
    puts "Loading seed data.... "

    user = User.create do |u|
      u.email = 'kenglish@gmail.com' 
      u.first_name = 'Kevin' 
      u.last_name = 'English' 
      u.mi = 'W' 
      u.title = '' 
      u.avatar = File.new(File.dirname(__FILE__) + '/../../test/fixtures/files/kevin_pic.jpg')
      u.password =  'kevin123'
      u.password_confirmation =  'kevin123'
    end

    xavier_user = User.create do |u|
      u.email = 'pochon@hawaii.edu' 
      u.first_name = 'Xavier' 
      u.last_name = 'Pochon' 
      u.mi = '' 
      u.title = '' 
      u.avatar = File.new(File.dirname(__FILE__) + '/../../test/fixtures/files/tigershark.jpg')
      u.password =  'xavier123'
      u.password_confirmation =  'xavier123'
    end

    user = User.create do |u|
      u.email = 'guylaine@hawaii.edu' 
      u.first_name = 'Guylaine' 
      u.last_name = 'Poisson' 
      u.mi = '' 
      u.title = '' 
      u.password =  'poisson123'
      u.avatar = File.new(File.dirname(__FILE__) + '/../../test/fixtures/files/poisson.jpg')
      u.password_confirmation =  'poisson123'
    end

    user = User.create do |u|
      u.email = 'hputnam@hawaii.edu' 
      u.first_name = 'Hollie' 
      u.last_name = 'Putnam' 
      u.mi = '' 
      u.title = '' 
      u.avatar = File.new(File.dirname(__FILE__) + '/../../test/fixtures/files/dolphin.jpg')
      u.password =  'hollie123'
      u.password_confirmation =  'hollie123'
    end

    user = User.create do |u|
      u.email = 'burkif@interchange.ubc.ca' 
      u.first_name = 'Burki' 
      u.last_name = 'Fabien' 
      u.mi = '' 
      u.title = '' 
      u.avatar = File.new(File.dirname(__FILE__) + '/../../test/fixtures/files/dolphin.jpg')
      u.password =  'burki123'
      u.password_confirmation =  'burki123'
    end

  end
end

namespace :db do

  desc "Give birth to the system (without going into labor)."
  task :rebirth => ["db:drop", "db:create", "db:migrate", "data:seed"]

end
