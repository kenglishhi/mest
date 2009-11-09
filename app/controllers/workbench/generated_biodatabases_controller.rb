class Workbench::GeneratedBiodatabasesController < ApplicationController
  include ExtJS::Controller

  def index

    biodatabase_type_ids = BiodatabaseType.generated_db_types.map {|t| t.id}

    data = Biodatabase.all :include => :biodatabase_group,
      :conditions => ['biodatabase_groups.project_id = ? and biodatabase_type_id in (?)',
      current_user.active_project.id, biodatabase_type_ids  ],
      :order => 'biodatabases.name'

    results = Biodatabase.count(:include => :biodatabase_group,
      :conditions => ['biodatabase_groups.project_id = ?', current_user.active_project.id])
    render :json => {:results => results, :data => data.map{|row|row.to_record}}
 
  end
end
