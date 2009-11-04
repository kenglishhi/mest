class BiodatabaseGroupsController < ApplicationController
  before_filter :database_sub_nav

  active_scaffold :biodatabase_groups do |config|
    config.list.label = "Databases Groups"

    list_show_columns = [:name, :description, :user, :parent, :created_at]
    config.list.columns = list_show_columns
    config.show.columns = list_show_columns

    config.columns[:project].form_ui = :select
    config.columns[:parent].form_ui = :select

    create_update_columns = [:name, :description,:project,:parent]
    config.create.columns = create_update_columns
    config.update.columns = create_update_columns
  end

  def before_create_save(record)
    record.user_id = current_user.id
   end
   def conditions_for_collection
     ['biodatabase_groups.project_id = ?', current_user.active_project.id ]
   end
end
