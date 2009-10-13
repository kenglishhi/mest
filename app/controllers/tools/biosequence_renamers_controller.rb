class Tools::BiosequenceRenamersController < ApplicationController

  #  before_filter :database_sub_nav

  def new
    if Biodatabase.exists?(params[:biodatabase_id] )
      @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    end
  end

  def create
    @biodatabase = Biodatabase.find(params[:biodatabase_id] )

    #    respond_to do | format |
    #logger.error("[kenglish] t ype=#{format.inspect}")
    #      format.js {
    #unless params[:prefix].blank?
    #   @biodatabase.rename_sequences(params[:prefix])
    #      render :json => {:success => true,:msg=> "Data Saved"}
    #    else
    #      render :json => {:success => false,:msg=> "FAIL!"}
    #    end
    #      }
    #      format.html {

    unless params[:prefix].blank?
      @biodatabase.rename_sequences(params[:prefix])
      render :json => {:success => true,:msg=> "Data Saved"}
    else
      flash[:errors] = "Missing prefix"
      render :json => {:success => false,:msg=> "FAIL!"}
    end
    #      }
    #      format.ext_json {
    #        logger.error("[kenglish] Got Javascript request to create")
    #
    #      }
    #
    #    end
  end
end