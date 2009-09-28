class Workbench::BiodatabasesController < ApplicationController
  def index
    @biodatabases = Biodatabase.all
    render :json => { :data => @biodatabases }
 
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
