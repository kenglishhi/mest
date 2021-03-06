class Tools::ClustalwsController < ApplicationController
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
      obj = Biodatabase.find(params[:biodatabase_id] )
      job_name = "ClustalW Alignment for #{obj.name}"
      create_job(Jobs::Clustalw, job_name, current_user, params)
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
