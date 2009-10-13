class Workbench::BiosequencesController < ApplicationController
  include ExtJS::Controller
  def index
    page = get_page(Biosequence)
    if params[:biodatabase_id]
      biosequences = Biosequence.paginate :page => page,
        :include => :biodatabase_biosequences,
        :conditions => ['biodatabase_biosequences.biodatabase_id = ?', params[:biodatabase_id] ],
        :order => 'name'
      results =  Biosequence.count :include => :biodatabase_biosequences,
        :conditions => ['biodatabase_biosequences.biodatabase_id = ?', params[:biodatabase_id] ]
    else
      biosequences =  Biosequence.paginate :page => page
      results =  Biosequence.count
    end

    render :json => {:results => results, :data => biosequences}
  end
end
