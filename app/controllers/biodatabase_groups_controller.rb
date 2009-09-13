class BiodatabaseGroupsController < ApplicationController
  before_filter :generate_database_sub_nav

  active_scaffold :biodatabase_groups do |config|
    config.list.label = "Databases Groups"

    list_show_columns = [:name, :description,:user, :created_at, :updated_at]
    config.list.columns = list_show_columns
    config.show.columns = list_show_columns

    config.columns[:project].form_ui = :select

    create_update_columns = [:name, :description,:project]
    config.create.columns = create_update_columns
    config.update.columns = create_update_columns
  end

  def before_create_save(record)
    record.user_id = current_user.id
   end
end