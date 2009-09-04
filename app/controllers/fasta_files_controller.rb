class FastaFilesController < ApplicationController

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
#    config.action_links.add "Blast", :parameters => {:controller => 'blast'},
#    :action => 'index', :type => :table, :page => true
  end

  def create
    if request.post?
      logger.error("[kenglish] upload_many -- ")
      if params[:fasta_files]
        params[:fasta_files].each do | image_param |
          unless image_param[:uploaded_data].blank?
            fasta_file = FastaFile.new
            fasta_file.user = current_user
            logger.error("[kenglish] uploaded data is #{image_param[:uploaded_data].inspect}")
            fasta_file.fasta = image_param[:uploaded_data]
            fasta_file.is_generated = false
            fasta_file.save
          end
        end
      end
      redirect_back_or_default(:action => :index )
    end
  end
  def new

  end
  
  def after_create_save(record)
    logger.error("kenglish] called after_update_save " )

    redirect_to users_path
  end

  def extract_sequences
    fasta_file = FastaFile.find(params[:id])
    job_name = "Extract Sequences #{fasta_file.fasta_file_name}"
    extract_sequences_job = Jobs::ExtractSequences.new(job_name, :fasta_file_id => fasta_file.id)
    Job.create(:job_name => job_name,
      :handler => extract_sequences_job,
      :user => current_user)

    render :inline => 'Queued to Extract'    
  end

end
