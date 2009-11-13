class Tools::BlastGroupNtAppendsController < ApplicationController
  include Jobs::ControllerUtils
  def create
    if params[:biodatabase_group_id].blank?
      respond_to do |format|
        format.html {
          render :inline => 'Could not queue'
        }
        format.json {
          render :json => {:success => false,:msg=> "FAIL!"}
        }
      end
    else
      biodatabase_group = BiodatabaseGroup.find(params[:biodatabase_group_id] )
      job_name = "Append Blast NT matches for #{biodatabase_group.name}"
      create_job(Jobs::BlastGroupNtAppend,job_name,current_user,params)
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
