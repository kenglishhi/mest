class Workbench::TreesController < ApplicationController
  def show
#   respond_to do | type |
#      type.html { redirect_to '/workbench/'}
#      type.js {
        render :json => [BiodatabaseGroup.first.ext_tree(:expand_node => true)].to_json
#      }
#    end

  end
end
