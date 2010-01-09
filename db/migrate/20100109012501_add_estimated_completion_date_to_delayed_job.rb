class AddEstimatedCompletionDateToDelayedJob < ActiveRecord::Migration
  def self.up
    add_column :delayed_jobs, :estimated_completion_date, :datetime
  end

  def self.down
    remove_column :delayed_jobs, :estimated_completion_date
  end
end
