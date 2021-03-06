class Tools::GenerateFastasController < ApplicationController
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
      @biodatabase = Biodatabase.find(params[:biodatabase_id] )

      job_name = "Generate Fasta #{@biodatabase.name}"
      create_job(Jobs::GenerateFasta,job_name,current_user,params)
      respond_to do |format|
        format.html {
          render :inline => 'Queued to Generate'
        }
        format.json {
          render :json => {:success => true,:msg=> "Data Saved"}
        }
      end
    end
  end
end
