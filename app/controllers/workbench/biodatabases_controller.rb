class Workbench::BiodatabasesController < ApplicationController
  include ExtJS::Controller
  def index
    if params[:biodatabase_group_id] 
      biodatabases = Biodatabase.find_all_by_biodatabase_group_id(params[:biodatabase_group_id])
    else 
      biodatabases = Biodatabase.all
    end
    render :json => { :data => biodatabases }
 
  end
  def update
    biodatabase = Biodatabase.find(params[:id])
    render(:text => '', :status => (biodatabase.update_attributes(params["data"])) ? 204 : 500)
  end

  def move
    respond_to do | type |
      type.html { redirect_to '/workbench/'}
      type.js{
        biodatabase = Biodatabase.find(params[:id])
        new_biodatabase_group = BiodatabaseGroup.find(params[:new_biodatabase_group_id])
        biodatabase.biodatabase_group = new_biodatabase_group
        biodatabase.save
        render :json => {:result => 'OK' }.to_json
      }
    end
  end

end
