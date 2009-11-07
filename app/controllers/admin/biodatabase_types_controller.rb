class BiodatabaseTypesController < Admin::BaseController  
  before_filter :database_sub_nav

  active_scaffold :biodatabase_types do |config|
    config.list.label = "Databases Types"

    list_show_columns = [:name ]
    config.list.columns = list_show_columns
    config.show.columns = list_show_columns

    create_update_columns = [:name]
    config.create.columns = create_update_columns
    config.update.columns = create_update_columns
  end

end
