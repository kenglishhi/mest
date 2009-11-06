class AddProjectToJobs < ActiveRecord::Migration
  def self.up
    add_column :delayed_jobs, :project_id, :integer
    add_column :job_logs, :project_id, :integer
  end

  def self.down
    remove_column :delayed_jobs, :project_id
    remove_column :job_logs, :project_id
  end
end
