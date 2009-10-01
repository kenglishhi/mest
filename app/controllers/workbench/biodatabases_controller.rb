class Workbench::BiodatabasesController < ApplicationController
  def index
    if params[:biodatabase_group_id] 
      @biodatabases = Biodatabase.find_all_by_biodatabase_group_id(params[:biodatabase_group_id])
    else 
      @biodatabases = Biodatabase.all
    end
    render :json => { :data => @biodatabases }
 
  end
  def update
    @biodatabase = Biodatabase.find(params[:id])

    if @biodatabase.update_attributes(ActiveSupport::JSON.decode(params[:data]))
      render :json => { :success => true, :message => "Updated Database #{@biodatabase.id}", :data => @biodatabase }
    else
      render :json => { :message => "Failed to update Database"}
    end
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
