class Workbench::BiosequencesController < ApplicationController
  def index
    @biosequences = Biosequence.all
    render :json => { :data => @biosequences}
  end
end
