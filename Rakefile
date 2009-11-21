# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

#require(File.join(File.dirname(__FILE__), 'config', 'boot'))
#
#require 'rake'
#require 'rake/testtask'
#require 'rake/rdoctask'
#
#require 'tasks/rails'
#


require(File.join(File.dirname(__FILE__), 'config', 'boot'))
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'
require 'shoulda/tasks'

def run_coverage(files)
  rm_f "coverage"
  rm_f "coverage.data"

  # turn the files we want to run into a  string
  if files.length == 0
    puts "No files were specified for testing"
    return
  end

  files = files.join(" ")

  if PLATFORM =~ /darwin/
    exclude = '--exclude "gems/*"'
  else
    exclude = '--exclude "rubygems/*"'
  end

  rcov = "rcov --rails -Ilib:test --sort coverage --text-report #{exclude}  --aggregate coverage.data"
  cmd = "#{rcov} #{files}"
  puts cmd
  sh cmd
end

namespace :test do

  desc "Measures unit, functional, and integration test coverage"
  task :coverage do
    run_coverage Dir["test/**/*.rb"]
  end

  namespace :coverage do
    desc "Runs coverage on unit tests"
    task :units do
      run_coverage Dir["test/unit/**/*.rb"]
    end
    desc "Runs coverage on functional tests"
    task :functionals do
      run_coverage Dir["test/functional/**/*.rb"]
    end
    desc "Runs coverage on integration tests"
    task :integration do
      run_coverage Dir["test/integration/**/*.rb"]
    end
  end
end
