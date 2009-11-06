class ProjectsController < ApplicationController

  active_scaffold :projects do |config|
    config.actions.exclude :nested
    config.list.label = "Projects"
    config.columns[:user].label = "Owner"
    list_show_columns = [:name, :description,:user, :created_at, :updated_at]
    config.list.columns = list_show_columns
    config.show.columns = list_show_columns 

    create_update_columns = [:name, :description]
    config.create.columns = create_update_columns 
    config.update.columns = create_update_columns 
  end
  def before_create_save(record)
    record.user_id = current_user.id
   end
end
