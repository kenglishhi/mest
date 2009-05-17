class BiodatabasesController < ApplicationController
  active_scaffold :biodatabases do |config|
    config.list.label = "Databases"
    config.list.columns = [:name, :biodatabase_type, :type_action]
  end

  def conditions_for_collection
		logger.error("[kenglish] params[:biodatabase_type_id].blank? #{params[:biodatabase_type_id].blank?} ")
    unless params[:biodatabase_type_id].blank?
		  logger.error("[kenglish] params[:biodatabase_type_id].blank? #{params[:biodatabase_type_id].blank?} ")
      @biodatabase_type_id = params[:biodatabase_type_id].to_i
      [' biodatabase_type_id  = ? ', @biodatabase_type_id]
    end

  end

end
