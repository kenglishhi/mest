class Tools::BiosequenceRenamersController < ApplicationController

  before_filter :database_sub_nav

  def new
    if Biodatabase.exists?(params[:biodatabase_id] )
      @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    end
  end

  def create
    @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    unless params[:prefix].blank?
      @biodatabase.rename_sequences(params[:prefix])
      redirect_back_or_default  biosequences_path(:biodatabase_id => params[:biodatabase_id] )
    else 
      flash[:errors] = "Missing prefix"
      render :action => 'new'
    end
  end

end
