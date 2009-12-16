class AddParentIdToBiodatabase < ActiveRecord::Migration
  def self.up
    add_column :biodatabases, :parent_id, :integer, :null => true
  end

  def self.down
    remove_column :biodatabases, :parent_id
  end
end
