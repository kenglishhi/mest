class AddProjectIdToBiodatabase < ActiveRecord::Migration
  def self.up
    add_column :biodatabases, :project_id, :integer, :null => false
    Biodatabase.all.each do | db|
      db.project_id = BiodatabaseGroup.find(db.biodatabase_group_id).project_id if db.biodatabase_group_id > 0
    end
    BiodatabaseType.create(:name => BiodatabaseType::DATABASE_GROUP)

    remove_column :biodatabases, :biodatabase_group_id

  end

  def self.down
    remove_column :biodatabases, :project_id
  end
end
