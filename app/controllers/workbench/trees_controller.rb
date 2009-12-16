class Workbench::TreesController < ApplicationController
  def show
   respond_to do | type |
      type.json {
        tree_data = current_user.active_project.ext_tree(:expand_node => true)
        render :json => tree_data.to_json
      }
    end
  end
end
