class CreateBiodatabaseGroups < ActiveRecord::Migration
  def self.up
    create_table :biodatabase_groups do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.integer :project_id
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :biodatabase_groups
  end
end
