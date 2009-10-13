class Workbench::BiodatabasesController < ApplicationController
  include ExtJS::Controller
  def index
    page = get_page(Biodatabase)
    if params[:id]
      biodatabases =[ Biodatabase.find(params[:id])]
    elsif params[:biodatabase_group_id]
      condition = ['biodatabase_group_id=?', params[:biodatabase_group_id]]
      biodatabases = Biodatabase.paginate :page => page, :condition => condition
      results = Biodatabase.count :condition => condition
    else 
      biodatabases = Biodatabase.paginate :page => page
      results = Biodatabase.count
    end
    render :json => {:results => results, :data => biodatabases.map{|db|db.to_record}}
 
  end
  def update
    biodatabase = Biodatabase.find(params[:id])
    logger.error("[kenglish] updating biodatabase = #{biodatabase}")
    logger.error("[kenglish] updating biodatabase = #{params[:data].inspect}")
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
  def show
    biodatabase = Biodatabase.find(params[:id])
    render :json =>  {:data => [biodatabase.to_record]}
  end


end
