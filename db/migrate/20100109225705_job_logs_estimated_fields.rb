class JobLogsEstimatedFields < ActiveRecord::Migration
  def self.up
    add_column :job_logs, :estimated_completion_date, :datetime
    add_column :job_logs, :estimation_error_seconds, :integer
  end

  def self.down
    remove_column :job_logs, :estimated_completion_date
    remove_column :job_logs, :estimation_error_seconds
  end
end
