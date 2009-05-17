class BiosequencesController < ApplicationController
  active_scaffold :biosequences do |config|
    config.list.label = "Sequences"

    config.columns = [:name, :seq, :length, :alphabet, :biodatabases]
    config.columns[:biodatabases].includes = [:biodatabase_biosequences]
    config.list.columns = [:name, :seq, :length, :alphabet,:biodatabases]
    config.show.columns = [ :name, :entire_seq, :length, :alphabet, :biodatabases]
    config.actions.exclude :nested , :create
  end

  def conditions_for_collection
    unless params[:biodatabase_id].blank?
      @biodatabase_id = params[:biodatabase_id].to_i
      ['biodatabase_biosequences.biodatabase_id = ? ', @biodatabase_id]
    end
  end

end
