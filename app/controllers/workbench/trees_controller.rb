class Workbench::TreesController < ApplicationController
  def show
   respond_to do | type |
#      type.html { redirect_to '/workbench/'}
      type.json {
        dbg = BiodatabaseGroup.main_group_in_project(current_user.active_project).first
        render :json => [dbg.ext_tree(:expand_node => true)].to_json
      }
    end

  end
end
