class Tools::ExtractSequencesController < ApplicationController
  include Jobs::ControllerUtils
  def create
    if params[:fasta_file_id].blank?
      respond_to do |format|
        format.html {
          render :inline => 'Could not queue'
        }
        format.json {
          render :json => {:success => false,:msg=> "FAIL!"}
        }
      end
    else
      fasta_file = FastaFile.find(params[:fasta_file_id])
      job_name = "Extract Sequences from #{fasta_file.fasta_file_name}"
      create_job(Jobs::ExtractSequences, job_name, current_user, params)
      respond_to do |format|
        format.html {
          render :inline => 'Queued to Extract'
        }
        format.json {
          render :json => {:success => true,:msg=> "Data Saved"}
        }
      end
    end
  end
end
