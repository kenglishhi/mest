class Tools::BlastCreateDbsController < ApplicationController
  def new
    if params[:test_biodatabase_id]

    end
    if Biodatabase.exists?(params[:test_biodatabase_id] )
      @test_biodatabase = Biodatabase.find(params[:test_biodatabase_id] )
    end
    #    @blast_command = BlastCommand.new(:evalue => 0.0001, :query_fasta_file_id => @biodatabase.fasta_file_id)
    #    @blast_command.biodatabase_type_id = BiodatabaseType.find_by_name("UPLOADED-CLEANED").id
    @fasta_file_options =  FastaFile.find(:all, :order => 'label' ).map { |ff| [ff.label, ff.id ] }
  end
  def create
    test_fasta_file = FastaFile.find(params[:test_fasta_file_id])
    target_fasta_file = FastaFile.find(params[:target_fasta_file_id])
    job_name = "Blasting #{test_fasta_file.label} against #{target_fasta_file.label} "
    job_handler = Jobs::BlastAndCreateDbs.new(job_name, params.merge(:user_id => current_user.id))
    Job.create(:job_name => job_name,
      :handler => job_handler,
      :user => current_user)

    redirect_back_or_default biodatabases_path
  end

end
