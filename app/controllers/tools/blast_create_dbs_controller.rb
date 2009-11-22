class Tools::BlastCreateDbsController < ApplicationController
  include Jobs::ControllerUtils
  def new
    if Biodatabase.exists?(params[:test_biodatabase_id] )
      @test_biodatabase = Biodatabase.find(params[:test_biodatabase_id] )
    end
    params[:evalue] = 25 unless params[:evalue]
  end

  def create
    @test_biodatabase = Biodatabase.find(params[:test_biodatabase_id] )
    @target_biodatabases = Biodatabase.all(:conditions => ["id in (?)",params[:target_biodatabase_ids]] ) 

    if (!params[:output_biodatabase_group_name].blank? &&
        BiodatabaseGroup.exists?(['name =? ', params[:output_biodatabase_group_name]]) ) ||
      @target_biodatabases.empty?
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
      target_db_names = @target_biodatabases.map{|db| db.name}.join(',')
      job_name = "Blasting #{@test_biodatabase.name} against #{target_db_names} "
      create_job(Jobs::BlastAndCreateDbs, job_name, current_user, params)
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
end
