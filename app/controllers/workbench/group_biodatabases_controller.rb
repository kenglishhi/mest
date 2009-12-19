class Workbench::GroupBiodatabasesController < ApplicationController
  include ExtJS::Controller

  def index
    biodatabase_type_id = BiodatabaseType.database_group.id
    data = Biodatabase.all(:conditions => ['project_id = ? and biodatabase_type_id  =  ?  AND parent_id is not null',
        current_user.active_project.id, biodatabase_type_id ],
      :order => 'biodatabases.name')
    results = Biodatabase.count(:conditions => ['project_id = ? and biodatabase_type_id  =  ? AND parent_id is not null',
        current_user.active_project.id, biodatabase_type_id ])
    render :json => {:results => results, :data => data.map{|row|row.to_record}}
 
  end

end
