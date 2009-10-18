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
      @new_biodatabase = Biodatabase.create(:name => params[:new_biodatabase_name],
        :biodatabase_group =>BiodatabaseGroup.first,
        :biodatabase_type => BiodatabaseType.first)
      render :action => 'new'
      return
    else
      job_name = "Clean Database #{biodatabase.name}"
      job_name += " into #{params[:new_biodatabase_name]}" unless params[:new_biodatabase_name].blank?
      create_job(job_name)
      redirect_back_or_default biodatabases_path
    end

  end

  private

  def create_job(job_name)
    job_handler = Jobs::CleanDatabaseWithBlast.new(job_name, params.merge(:user_id => current_user.id))
    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => current_user)
  end

end
