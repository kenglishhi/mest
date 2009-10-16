class Workbench::HomeController < ApplicationController
  helper ExtJS::Helpers::Component
  helper ExtJS::Helpers::Store
  def index
    @project_options =  Project.workbench_project_options
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

end
