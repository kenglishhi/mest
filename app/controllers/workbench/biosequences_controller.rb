class Workbench::BiosequencesController < ApplicationController
  include ExtJS::Controller
  def index
    page = get_page(Biosequence)
    if params[:biodatabase_id]
      data = Biosequence.paginate :page => page,
        :include => :biodatabase_biosequences,
        :conditions => ['biodatabase_biosequences.biodatabase_id = ?', params[:biodatabase_id] ],
        :order => 'name'
      results =  Biosequence.count :include => :biodatabase_biosequences,
        :conditions => ['biodatabase_biosequences.biodatabase_id = ?', params[:biodatabase_id] ]
    else
      data =  Biosequence.paginate :page => page
      results =  Biosequence.count
    end

    render :json => {:results => results, :data => data.map{|row|row.to_record}}
  end
end
