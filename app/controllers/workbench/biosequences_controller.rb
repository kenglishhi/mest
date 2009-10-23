class Workbench::BiosequencesController < ApplicationController
  include ExtJS::Controller
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
end
