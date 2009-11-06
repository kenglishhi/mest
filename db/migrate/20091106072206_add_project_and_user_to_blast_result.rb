class AddProjectAndUserToBlastResult < ActiveRecord::Migration
  def self.up
    add_column :blast_results, :user_id, :integer
    add_column :blast_results, :project_id, :integer
  end

  def self.down
    remove_column :blast_results, :user_id
    remove_column :blast_results, :project_id
  end
end
