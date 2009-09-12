set :application, "biococonutisland"
set :repository,  "git@github.com:kenglishhi/biococonutisland.git"
set :scm, "git"
set :branch, "master"
set :shared_dir, "shared"
set :runner, 'kenglish'

set :deploy_to, "/Users/kenglish/webapp/#{application}"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

role :web, "gp202.ics.hawaii.edu"
role :app, "gp202.ics.hawaii.edu"
role :db,  "gp202.ics.hawaii.edu", :primary => true

namespace :deploy do

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

end

namespace :symlink do

  desc 'symlink database.yml'
  task :database_yml do
    run <<-CMD
      ln -fs #{shared_path}/config/database.yml #{release_path}/config/database.yml
    CMD
  end

end
namespace :delayed_job do

  desc 'restart delayed job'
  task :start do
    run <<-CMD
     ruby #{current_path}/script/delayed_job start production
    CMD
  end
  task :stop do
    run <<-CMD
     ruby #{current_path}/script/delayed_job  stop -f production 
    CMD
  end


end


#task :after_update_code, :roles => :app do
#  puts "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml " 
#  puts "------------------"
#  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
#end

after 'deploy:update_code', 'symlink:database_yml'
after 'symlink:database_yml', 'deploy:migrate'
before 'deploy:symlink', 'delayed_job:stop'
after 'deploy:symlink', 'delayed_job:start'
