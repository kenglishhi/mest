class Workbench::BlastResultsController < ApplicationController
  include ExtJS::Controller
  protect_from_forgery :except => :destroy
  def index
    page = get_page(BlastResult)
    if params[:output_biodatabase_id]
      data = BlastResult.paginate :page => page, :order => 'stopped_at DESC',
        :conditions =>['project_id = ? AND output_biodatabase_id = ? ', current_user.active_project.id,params[:output_biodatabase_id] ],
        :include => [:output_biodatabase,:test_biodatabase ]
    else
      data = BlastResult.paginate :page => page, :order => 'stopped_at DESC',
        :conditions => project_conditions
    end
    results =BlastResult.count
    render :json => {:results => results, :data => data.map{|row|row.to_record}}
  end
  def update
  end

  def create
  end
  def destroy
    #    @seq = BiodatabaseBiosequBiosequenceBio.find(params[:id])
    @blast_result = BlastResult.find(params[:id])
    if @blast_result.destroy
      render :json => { :success => true, :message => "Destroyed Blast " }
    else
      render :json => { :message => "Failed to destroy Blast Result" }
    end
  end
end
