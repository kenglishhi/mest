class Workbench::BiodatabaseGroupsController < ApplicationController
  def index
    @biodatabase_groups = BiodatabaseGroup.all
    render :json => { :data => @biodatabase_groups }
  end
  def update
    @biodatabase_group = BiodatabaseGroup.find(params[:id])

    if @biodatabase_group.update_attributes(ActiveSupport::JSON.decode(params[:data]))
      render :json => { :success => true, :message => "Updated Database Group #{@biodatabase_group.id}", :data => @biodatabase_group }
    else
      render :json => { :message => "Failed to update Database Group."}
    end
  end

  def create
    respond_to do | type |
      type.html { redirect_to '/workbench/'}
      type.js{
        parent_db = BiodatabaseGroup.find(params[:parent_id])
        biodatabase_group = BiodatabaseGroup.create(:name => params[:name],
          :parent_id => params[:parent_id],
          :project_id => parent_db.project_id,
          :user_id => current_user.id
        )
        params[:parent_id]
        render :json => {:result => 'OK',:id=>  biodatabase_group.id }.to_json
      }
    end
  end
  def move
    respond_to do | type |
      type.html { redirect_to '/workbench/'}
      type.js{
        biodatabase_group = BiodatabaseGroup.find(params[:id])
        new_parent = BiodatabaseGroup.find(params[:new_parent_id])
        biodatabase_group.parent = new_parent
        biodatabase_group.save
        render :json => {:result => 'OK' }.to_json
      }
    end
  end
  def tree
  end

end
