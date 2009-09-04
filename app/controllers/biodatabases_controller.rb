class BiodatabasesController < ApplicationController

  before_filter :clear_stored_location, :only => [:index]
  active_scaffold :biodatabases do |config|
    config.list.label = "Databases"
    config.columns = [:name, :biodatabase_type, :parent,:user]
    config.list.columns = [:name, :biodatabase_type, :fasta_file,:parent, :number_of_sequences,:user ]
    config.columns[:biodatabase_type].form_ui = :select
    config.columns[:parent].form_ui = :select
  end

	def clean
    @biodatabase = Biodatabase.find(params[:id] )
    @blast_command = BlastCommand.new(:evalue => 0.0001, :query_fasta_file_id => @biodatabase.fasta_file_id)
    @fasta_file_options =  FastaFile.find(:all, :order => 'label' ).map { |ff| [ff.label, ff.id ] }
	end

	def blast
	  @blast_command = BlastCommand.create(params[:blast_command]  )
    if @blast_command.valid?
      @blast_command.save
    else
      @fasta_file_options =  FastaFile.find(:all,:order => 'label' ).map { |ff| [ff.label, ff.id ] }
      render :action => 'blast_form'
    end
	end

  protected

  def conditions_for_collection
		logger.error("[kenglish] params[:biodatabase_type_id].blank? #{params[:biodatabase_type_id].blank?} ")
    unless params[:biodatabase_type_id].blank?
		  logger.error("[kenglish] params[:biodatabase_type_id].blank? #{params[:biodatabase_type_id].blank?} ")
      @biodatabase_type_id = params[:biodatabase_type_id].to_i
#      [' biodatabases.biodatabase_type_id  = ? ', @biodatabase_type_id]
    end
		[]
  end

end
