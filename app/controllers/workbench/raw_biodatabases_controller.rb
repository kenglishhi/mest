class Workbench::RawBiodatabasesController < ApplicationController
  include ExtJS::Controller

  def index

    biodatabase_type_ids = BiodatabaseType.raw_db_types.map {|t| t.id}

    data = Biodatabase.all :conditions => ['project_id = ? and biodatabase_type_id in (?)',
        current_user.active_project.id, biodatabase_type_ids  ],
      :order => 'biodatabases.name'

    results = Biodatabase.count(:conditions => ['project_id = ?', current_user.active_project.id])
    render :json => {:results => results, :data => data.map{|row|row.to_record}}
 
  end
end
