class Workbench::BiosequencesController < ApplicationController
  include ExtJS::Controller
  def index
    if params[:biodatabase_id]
      biosequences = Biodatabase.find(params[:biodatabase_id]).biosequences.collect{|bs| bs.to_record } 
    else
      biosequences = Biosequence.all.collect{|bs| bs.to_record }
    end
    render :json => { :data => biosequences}
  end
end
