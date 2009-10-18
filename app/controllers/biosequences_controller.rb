class BiosequencesController < ApplicationController

  before_filter :database_sub_nav

  active_scaffold :biosequences do |config|
    config.list.label = "Sequences"
    config.columns = [:name, :seq, :length, :alphabet]
    config.columns[:name].includes = [:biodatabase_biosequences]
    config.list.columns = [:name, :seq, :length, :alphabet,:original_name]
    config.show.columns = [:name, :entire_seq, :length, :alphabet, :biodatabases,:original_name]
    config.actions.exclude :nested , :create, :update, :delete
  end

  def conditions_for_collection
    params[:biodatabase_id] = Biodatabase.first.id if params[:biodatabase_id].blank?
    @biodatabase_id = params[:biodatabase_id].to_i
    ['biodatabase_biosequences.biodatabase_id = ? ', @biodatabase_id]
  end

end
