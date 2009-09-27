class Workbench::HomeController < ApplicationController
  def index
    @project_options =  Project.workbench_project_options
    render :layout => false
  end
end
