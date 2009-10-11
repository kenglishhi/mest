class Workbench::BiosequencesController < ApplicationController
  include ExtJS::Controller
  def index
    page = params[:start].blank? ? 1 : ((params[:start].to_i/Biosequence.per_page) + 1)
    logger.error("[kenglish] page = #{page}, biodatabase_id #{params[:biodatabase_id]}  " )
    if params[:biodatabase_id]
      biosequences = Biosequence.paginate :page => page,
        :include => :biodatabase_biosequences,
        :conditions => ['biodatabase_biosequences.biodatabase_id = ?', params[:biodatabase_id] ],
        :order => 'name'
    else
      biosequences =  Biosequence.paginate :page => page
    end
    hash = {
      :success=> true,
      :results=> 2000,
      :rows=> [
        { "id"=>  1, "name"=> "Bill", "occupation"=> "Gardener" },
        { "id"=>  2, "name"=>  "Ben", "occupation"=> "Horticulturalist" }
      ]
    } 

#    render :json => hash.to_json  # i{:success => true, :results => 2000, :data => biosequences}
    render :json => {:results => 2000, :data => biosequences}
  end
end
