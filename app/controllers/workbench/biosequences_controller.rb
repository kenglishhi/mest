class Workbench::BiosequencesController < ApplicationController
  include ExtJS::Controller
  protect_from_forgery :except => :destroy
  def index
    page = get_page(Biosequence)
    if params[:biodatabase_id]
      conditions = []
      if !params[:query].blank?
        conditions = ['biodatabase_biosequences.biodatabase_id = ? AND name like ? ',
          params[:biodatabase_id] , "#{params[:query]}%" ]
      else
        conditions = ['biodatabase_biosequences.biodatabase_id = ?', params[:biodatabase_id] ]
      end
      data = Biosequence.paginate :page => page,
        :include => :biodatabase_biosequences,
        :conditions => conditions,
        :order => 'name'
      results =  Biosequence.count :include => :biodatabase_biosequences,
        :conditions => conditions
    else
      conditions = []
      if !params[:query].blank?
        conditions = ['name like ? ', "#{params[:query]}%" ]
      end

      data =  Biosequence.paginate :page => page, :conditions => conditions
      results =  Biosequence.count
    end

    render :json => {:results => results, :data => data.map{|row|row.to_record}}
  end
  def destroy
    #    @seq = BiodatabaseBiosequBiosequenceBio.find(params[:id])
    @seq = BiodatabaseBiosequence.find_by_biosequence_id_and_biodatabase_id(params[:id],params[:biodatabase_id])
    if @seq  #@job.destroy
      render :json => { :success => true, :message => "Destroyed job " }
    else
      render :json => { :message => "Failed to destroy Job" }
    end
  end
end
