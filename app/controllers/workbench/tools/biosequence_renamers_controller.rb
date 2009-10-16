class Workbench::Tools::BiosequenceRenamersController < ApplicationController

  def new
    if Biodatabase.exists?(params[:biodatabase_id] )
      @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    end
  end

  def create
    @biodatabase = Biodatabase.find(params[:biodatabase_id] )

    unless params[:prefix].blank?
      @biodatabase.rename_sequences(params[:prefix])
      render :json => {:success => true,:msg=> "Data Saved"}
    else
      flash[:errors] = "Missing prefix"
      render :json => {:success => false,:msg=> "FAIL!"}
    end
  end
end
