class Tools::BiosequenceRenamersController < ApplicationController
  include Jobs::ControllerUtils

  def new
    if Biodatabase.exists?(params[:biodatabase_id] )
      @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    end
  end

  def create
    @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    if params[:prefix].blank?
      flash[:errors] = "Missing prefix"
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
        format.json {
          render :json => {:success => false,:msg=> "FAIL!"}
        }
      end
    else
      job_name = "Rename sequences in database #{@biodatabase.name}"
      create_job(Jobs::RenameSequencesInDb, job_name, current_user, params)

      respond_to do |format|
        format.html {
          redirect_back_or_default  biosequences_path(:biodatabase_id => params[:biodatabase_id] )
        }
        format.json {
          render :json => {:success => true,:msg=> "Data Saved"}
        }
      end
    end
  end
end