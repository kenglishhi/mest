class ProjectsController < ApplicationController

  active_scaffold :projects do |config|
    config.list.label = "Databases Groups"
  end
end
