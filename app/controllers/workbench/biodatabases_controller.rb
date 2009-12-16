class Workbench::BiodatabasesController < ApplicationController
  include ExtJS::Controller
  include Jobs::ControllerUtils

  def index
    page = get_page(Biodatabase)
    if params[:id]
      data =[ Biodatabase.find(params[:id])]
    else 
      data = Biodatabase.paginate :page => page, 
        :conditions => ['project_id = ?', current_user.active_project.id],
        :order => 'biodatabases.name'
      results = Biodatabase.count(:conditions => ['project_id = ?', current_user.active_project.id])
    end
    render :json => {:results => results, :data => data.map{|row|row.to_record}}
 
  end

  def update
    biodatabase = Biodatabase.find(params[:id])
    logger.error("[kenglish] updating biodatabase = #{biodatabase}")
    logger.error("[kenglish] updating biodatabase = #{params[:data].inspect}")
    render(:text => '', :status => (biodatabase.update_attributes(params["data"])) ? 204 : 500)
  end

  def destroy
    record = Biodatabase.find(params[:id])
    status = record.destroy
    job_name = "Purge unassignemd sequences"
    create_job(Jobs::PurgeUnassignedSequences, job_name, current_user, params)
    render(:text => '', :status => status ? 204 : 500)
  end

  def move
    respond_to do | type |
#      type.html { redirect_to '/workbench/'}
#      type.js{
#        biodatabase = Biodatabase.find(params[:id])
#        new_biodatabase_group = BiodatabaseGroup.find(params[:new_biodatabase_group_id])
#        biodatabase.biodatabase_group = new_biodatabase_group
#        biodatabase.save
#        render :json => {:result => 'OK' }.to_json
#      }
    end
  end

  def show
    biodatabase = Biodatabase.find(params[:id])
    render :json =>  {:data => [biodatabase.to_record]}
  end


end
