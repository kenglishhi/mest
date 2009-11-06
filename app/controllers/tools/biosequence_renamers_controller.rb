class Tools::BiosequenceRenamersController < ApplicationController

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
      create_job(job_name)

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
  private
  def create_job(job_name)
    job_handler = Jobs::RenameSequencesInDb.new(job_name)
    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => current_user,
      :project => current_user.active_project)
  end

end