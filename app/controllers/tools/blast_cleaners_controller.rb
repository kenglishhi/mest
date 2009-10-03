class Tools::BlastCleanersController < ApplicationController
  def new
    if Biodatabase.exists?(params[:biodatabase_id] )
      @biodatabase = Biodatabase.find(params[:biodatabase_id] )
    end
#    @blast_command = BlastCommand.new(:evalue => 0.0001, :query_fasta_file_id => @biodatabase.fasta_file_id)
#    @blast_command.biodatabase_type_id = BiodatabaseType.find_by_name("UPLOADED-CLEANED").id

    params[:evalue] = 25 unless params[:evalue]
    @fasta_file_options =  FastaFile.find(:all, :order => 'label' ).map { |ff| [ff.label, ff.id ] }
  end
  def create
    fasta_file = FastaFile.find(params[:fasta_file_id])
    job_name = "Clean File #{fasta_file.fasta_file_name}"
    job_handler = Jobs::CleanFileWithBlast.new(job_name, params.merge(:user_id => current_user.id))

    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => current_user)
    redirect_back_or_default biodatabases_path
  end

end
