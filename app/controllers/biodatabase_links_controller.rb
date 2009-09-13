class BiodatabaseLinksController < ApplicationController
  before_filter :generate_database_sub_nav
  active_scaffold :biodatabase_links do |config|
    config.list.label = "Databases Link Types"
    config.actions.exclude :nested
    list_show_columns = [:biodatabase, :linked_biodatabase,:biodatabase_link_type]
    config.list.columns = list_show_columns
    config.show.columns = list_show_columns

    create_update_columns = [:name, :description]
    config.create.columns = create_update_columns
    config.update.columns = create_update_columns
  end

end
