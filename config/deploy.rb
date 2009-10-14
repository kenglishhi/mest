



set :application, "biococonutisland"
set :repository,  "git@github.com:kenglishhi/biococonutisland.git"
set :scm, "git"
set :branch, "master"
set :shared_dir, "shared"
set :runner, 'www'

set :deploy_to, "/Users/kenglish/webapp/biococonutisland"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

role :web, "gp202.ics.hawaii.edu"
role :app, "gp202.ics.hawaii.edu"
role :db,  "gp202.ics.hawaii.edu", :primary => true

namespace :deploy do

  desc "Restart Application"
  task :restart, :roles => :app do
   sudo_as_www "touch #{current_path}/tmp/restart.txt"
  end

end

namespace :symlink do

  desc 'symlink database.yml'
  task :database_yml do
    run <<-CMD
      ln -fs #{shared_path}/config/database.yml #{release_path}/config/database.yml
    CMD
  end
  task :chown_to_www do
    sudo  "chown -R www:www #{current_path}"
    sudo  "chown -R www:www #{current_path}/*"
  end

end

namespace :delayed_job do

  desc 'restart delayed job'
  task :start do
    run "sleep 3"
    sudo_as_www "ruby #{current_path}/script/delayed_job_production start"
  end
 task :stop do
    sudo_as_www " ruby #{current_path}/script/delayed_job_production stop"
    run "sleep 5"
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
after 'delayed_job:start', 'symlink:chown_to_www'



def sudo_as_www(cmd)
    cmd =<<-CMD
      sh -c "#{cmd}"
    CMD
    sudo cmd, :as => 'www'
end

