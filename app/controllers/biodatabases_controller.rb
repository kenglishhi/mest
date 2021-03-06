class BiodatabasesController < ApplicationController

  before_filter :database_sub_nav
  before_filter :clear_stored_location, :only => [:index]

  active_scaffold :biodatabases do |config|
    config.actions.exclude :nested, :create

    config.list.label = "Databases"
    config.columns = [:name, :biodatabase_type, :user]
    config.list.columns = [:name, :biodatabase_type,  :fasta_file,:number_of_sequences,:user]
    config.update.columns = [:name, :biodatabase_type ]
    config.columns[:biodatabase_type].form_ui = :select
  end

  protected

  def conditions_for_collection
		logger.error("[kenglish] params[:biodatabase_type_id].blank? #{params[:biodatabase_type_id].blank?} ")
    unless params[:biodatabase_type_id].blank?
		  logger.error("[kenglish] params[:biodatabase_type_id].blank? #{params[:biodatabase_type_id].blank?} ")
      @biodatabase_type_id = params[:biodatabase_type_id].to_i
      [' biodatabases.biodatabase_type_id  = ? ', @biodatabase_type_id]
    end
  end

end
