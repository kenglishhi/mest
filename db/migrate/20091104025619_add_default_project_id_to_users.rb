class AddDefaultProjectIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :default_project_id, :integer
    User.all.each do |user|
       unless user.default_project_id
         user.create_default_project
       end
    end
  end

  def self.down
    remove_column :users, :default_project_id
  end
end
