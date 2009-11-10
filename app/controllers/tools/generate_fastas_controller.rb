class Tools::GenerateFastasController < ApplicationController
  def create
    @biodatabase = Biodatabase.find(params[:biodatabase_id] )

    job_name = "Generate Fasta #{@biodatabase.name}"
    create_job(job_name)
    respond_to do |format|
      format.html {

        render :inline => 'Queued to Generate'
      }
      format.json {
        render :json => {:success => true,:msg=> "Data Saved"}
      }
    end

  end
  private
  def create_job(job_name)
    job_handler = Jobs::GenerateFasta.new(job_name,params)
    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => current_user,
      :project => current_user.active_project )

  end
end
