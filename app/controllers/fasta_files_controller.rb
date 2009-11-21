class FastaFilesController < ApplicationController

  before_filter :database_sub_nav

  before_filter :clear_stored_location, :only => [:index]
  active_scaffold :fasta_files do |config|
    config.list.label = "Fasta Files"
    config.list.columns = [:label, :fasta_file_name, :fasta_file_size, :biodatabase_extract,:user]
    config.create.multipart = true
    config.create.columns = [:label, :fasta, ]
    config.update.columns = [:label]
    config.show.columns = [:label, :fasta_file_name, :fasta_file_size,:created_at,:fasta_data]
    config.action_links.add "Upload Files", :action => 'new', :type => :table, :page => true
    config.actions.exclude :create, :show
  end

  def create
    if request.post?
      logger.error("[kenglish] upload_many -- ")
      if params[:fasta_files]
        params[:fasta_files].each do | image_param |
          unless image_param[:uploaded_data].blank?
            fasta_file = FastaFile.new
            fasta_file.user = current_user
            fasta_file.project_id = params[:project_id]
            logger.error("[kenglish] uploaded data is #{image_param[:uploaded_data].inspect}")
            fasta_file.fasta = image_param[:uploaded_data]
            fasta_file.is_generated = false
            fasta_file.save!
          end
        end
      end
      redirect_back_or_default(:action => :index )
    end
  end

  def new
    @projects = Project.find(:all).map { |p| ["#{p.name} (#{p.user.full_name}) ", p.id] }
  end
  
  def after_create_save(record)
    logger.error("kenglish] called after_update_save " )
    redirect_to users_path
  end

  def conditions_for_collection
		logger.error("[kenglish] params[:biodatabase_type_id].blank? #{params[:biodatabase_type_id].blank?} ")
    unless params[:biodatabase_type_id].blank?
		  logger.error("[kenglish] params[:biodatabase_type_id].blank? #{params[:biodatabase_type_id].blank?} ")
      @biodatabase_type_id = params[:biodatabase_type_id].to_i
    end
    ['fasta_files.project_id = ?', current_user.active_project.id ]
  end
end
