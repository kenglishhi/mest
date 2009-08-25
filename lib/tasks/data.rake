namespace :data do

  desc "Load seed data"
  task :seed do
    puts "Load seed data --- HERE"
  end
end

namespace :db do

  desc "Give birth to the system (without going into labor)."
  task :rebirth => ["db:drop", "db:create", "db:migrate", "data:seed"]

end
