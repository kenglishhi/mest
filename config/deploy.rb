set :application, "biococonutisland"
set :repository,  "git@github.com:kenglishhi/biococonutisland.git"
set :scm, "git"
set :branch, "master"
set :shared_dir, "shared"

set :deploy_to, "/Users/kenglish/webapp/#{application}"

role :web, "gp202.ics.hawaii.edu"
role :app, "gp202.ics.hawaii.edu"
role :db,  "gp202.ics.hawaii.edu", :primary => true

