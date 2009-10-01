class Workbench::BiosequencesController < ApplicationController
  def index
    if params[:biodatabase_id]
      @biosequences = Biodatabase.find(params[:biodatabase_id]).biosequences
    else
      @biosequences = Biosequence.all
    end
    render :json => { :data => @biosequences}
  end
end
