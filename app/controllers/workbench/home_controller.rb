class Workbench::HomeController < ApplicationController
  helper ExtJS::Helpers::Component
  helper ExtJS::Helpers::Store
  def index
    @project_options =  Project.workbench_project_options
    @biodatabase_group = BiodatabaseGroup.main_group_in_project(current_user.active_project).first
    render :layout => false
  end

  def storetest
    render :layout => false
  end

  def rename_form
    render :layout => false
  end
  def rename
    render :layout => false
  end
 def slide
    render :layout => false
  end
 def user_job_notifications
    render :layout => false
  end
  def ncbi_blast
    render :layout => false
  end

end
