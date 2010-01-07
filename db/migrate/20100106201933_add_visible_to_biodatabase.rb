class AddVisibleToBiodatabase < ActiveRecord::Migration
  def self.up
    add_column :biodatabases, :visible, :boolean, :default => true,:null => false
  end

  def self.down
    remove_column :biodatabases, :visible
  end
end
