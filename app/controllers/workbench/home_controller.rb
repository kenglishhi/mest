class Workbench::HomeController < ApplicationController
  helper ExtJS::Helpers::Component
  helper ExtJS::Helpers::Store
  def index
    @biodatabase_group = BiodatabaseGroup.main_group_in_project(current_user.active_project).first
    render :layout => false
  end
  def fasta_file_upload
    render :layout => false
  end
  def alignment_panel
    render :layout => false
  end
  def blast_help_window
    render :layout => false
  end
  def change_project
    change_active_project(Project.find(params[:id]))
    redirect_to '/workbench'
  end
#  def storetest
#    render :layout => false
#  end
#
#  def rename_form
#    render :layout => false
#  end
#  def rename
#    render :layout => false
#  end
# def slide
#    render :layout => false
#  end
# def user_job_notifications
#    render :layout => false
#  end
#  def ncbi_blast
#    render :layout => false
#  end

end
