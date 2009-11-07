class BiodatabaseLinkTypesController < Admin::BaseController  
  before_filter :database_sub_nav
  active_scaffold :biodatabase_link_types do |config|
    config.list.label = "Databases Link Types"

    list_show_columns = [:name, :description]
    config.list.columns = list_show_columns
    config.show.columns = list_show_columns

    create_update_columns = [:name, :description]
    config.create.columns = create_update_columns
    config.update.columns = create_update_columns
  end
end
