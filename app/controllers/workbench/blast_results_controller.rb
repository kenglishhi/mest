class Workbench::BlastResultsController < ApplicationController
 include ExtJS::Controller
  def index
    page = get_page(BlastResult)
    data = BlastResult.paginate :page => page, :order => 'stopped_at DESC',
      :conditions => project_conditions
    results =BlastResult.count
    render :json => {:results => results, :data => data.map{|row|row.to_record}}
  end
  def update
#    biodatabase_group = BiodatabaseGroup.find(params[:id])
#    render(:text => '', :status => (biodatabase_group.update_attributes(params["data"])) ? 204 : 500)
  end

  def create
#    respond_to do | type |
#      type.html { redirect_to '/workbench/'}
#      type.js{
#        parent_db = BiodatabaseGroup.find(params[:parent_id])
#        biodatabase_group = BiodatabaseGroup.create(:name => params[:name],
#          :parent_id => params[:parent_id],
#          :project_id => parent_db.project_id,
#          :user_id => current_user.id
#        )
#        params[:parent_id]
#        render :json => {:result => 'OK',:id=>  biodatabase_group.id }.to_json
#      }
#    end
  end
end
