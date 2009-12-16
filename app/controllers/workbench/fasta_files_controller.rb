class Workbench::FastaFilesController < ApplicationController
  include ExtJS::Controller
  include Jobs::ControllerUtils

  def index
    page = get_page(FastaFile)
    data = FastaFile.paginate :page => page,
      :conditions => ['is_generated = 0 AND project_id = ?', current_user.active_project.id],
      :order => 'label'
    results = FastaFile.count(:conditions => ['is_generated = 0 AND project_id = ?', current_user.active_project.id])
    render :json => {:results => results, :data => data.map{|row| row.to_record}}
end

  def update
  end

  def destroy
  end

  def show
  end

end
