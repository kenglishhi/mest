class Workbench::BiosequencesController < ApplicationController
  def index
    @biosequences = Biosequences.all
    render :json => { :data => @biosequences}
  end
end
