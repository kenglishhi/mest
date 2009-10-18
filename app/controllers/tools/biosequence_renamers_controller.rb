class Tools::BiosequenceRenamersController < ApplicationController

  def new
    if Biodatabase.exists?(params[:biodatabase_id] )
      @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    end
  end

  def create
    @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    unless params[:prefix].blank?
      job_name = "Rename sequences in database #{@biodatabase.name}"
      create_job(job_name)

      respond_to do |format|
        format.html {
          redirect_back_or_default  biosequences_path(:biodatabase_id => params[:biodatabase_id] )
        }
        format.json {
          render :json => {:success => true,:msg=> "Data Saved"}
        }
      end
    else
      flash[:errors] = "Missing prefix"
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
        format.json {
          render :json => {:success => false,:msg=> "FAIL!"}
        }
      end
    end
  end
  private
  def create_job(job_name)
    job_handler = Jobs::RenameSequencesInDb.new(job_name, params.merge(:user_id => current_user.id))
    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => current_user)
  end

end