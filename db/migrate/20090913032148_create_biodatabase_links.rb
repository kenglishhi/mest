class CreateBiodatabaseLinks < ActiveRecord::Migration
  def self.up
    create_table :biodatabase_links do |t|
      t.column :biodatabase_id, :integer, :null => false
      t.column :linked_biodatabase_id, :integer, :null => false
      t.column :biodatabase_link_type_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :biodatabase_links
  end
end
