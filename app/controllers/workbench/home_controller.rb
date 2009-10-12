class Workbench::HomeController < ApplicationController
  helper ExtJS::Helpers::Component
  helper ExtJS::Helpers::Store
  def index
    @project_options =  Project.workbench_project_options
    render :layout => false
  end
end
