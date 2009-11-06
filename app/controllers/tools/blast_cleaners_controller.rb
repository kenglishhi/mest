class Tools::BlastCleanersController < ApplicationController
  def new
    if Biodatabase.exists?(params[:biodatabase_id] )
      @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    end
    params[:evalue] = 25 unless params[:evalue]
  end
  def create
    biodatabase = Biodatabase.find(params[:biodatabase_id])

    if !params[:new_biodatabase_name].blank? && Biodatabase.exists?(['name =? ', params[:new_biodatabase_name]])
      flash[:errors] = "New Database Name already exists."
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
        format.json {
          render :json => {:success => false,
            :errors => [{
                :id => 'new_biodatabase_name',
                :msg => "Sorry man, New Database Name already exists." }]
            }
        }
      end
      return
    else
      job_name = "Clean Database #{biodatabase.name}"
      job_name += " into #{params[:new_biodatabase_name]}" unless params[:new_biodatabase_name].blank?
      create_job(job_name)
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

  private

  def create_job(job_name)
    job_handler = Jobs::CleanDatabaseWithBlast.new(job_name)
    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => current_user,
      :project => current_user.active_project )
  end

end
