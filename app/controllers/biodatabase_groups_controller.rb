class BiodatabaseGroupsController < ApplicationController
  active_scaffold :biodatabase_groups do |config|
    config.list.label = "Databases Groups"
  end

end
