class BiodatabasesController < ApplicationController
  active_scaffold :biodatabases do |config|
    config.list.label = "Databases"
    config.list.columns = [:name, :biodatabase_type]
  end
end
