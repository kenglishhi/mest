class Tools::BlastCreateDbsController < ApplicationController
  def new

    if Biodatabase.exists?(params[:test_biodatabase_id] )
      @test_biodatabase = Biodatabase.find(params[:test_biodatabase_id] )
    end
    params[:evalue] = 25 unless params[:evalue]
  end

  def create
    @test_biodatabase = Biodatabase.find(params[:test_biodatabase_id] )
    @target_biodatabase = Biodatabase.find(params[:target_biodatabase_id] )

    if !params[:output_biodatabase_group_name].blank? && BiodatabaseGroup.exists?(['name =? ', params[:output_biodatabase_group_name]])
      flash[:errors] = "Output Database Group Name already exists."
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
        format.json {
          render :json => {:success => false,
            :errors => [{
                :id => 'output_biodatabase_group_name',
                :msg => "Sorry man, Output Database Group Name already exists." }]
          }
        }
      end
      return
    else
      job_name = "Blasting #{@test_biodatabase.name} against #{@target_biodatabase.name} "
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
    job_handler = Jobs::BlastAndCreateDbs.new(job_name,params)
    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => current_user,
      :project => current_user.active_project )

  end
end
