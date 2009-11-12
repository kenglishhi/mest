class Tools::BlastNtAppendsController < ApplicationController
  include Jobs::ControllerUtils
   def create
    if params[:biodatabase_id].blank?
      respond_to do |format|
        format.html {
          render :inline => 'Could not queue'
        }
        format.json {
          render :json => {:success => false,:msg=> "FAIL!"}
        }
      end
    else
      biodatabase = Biodatabase.find(params[:biodatabase_id] )
      job_name = "Append Blast NT matches for #{biodatabase.name}"
      create_job(Jobs::BlastNtAppend,job_name,current_user,params)
      respond_to do |format|
        format.html {
          redirect_back_or_default biodatabases_path
        }
        format.json {
          render :json => {:success => true,:msg=> "Data Saved"}
        }
      end
    end
  end
end
