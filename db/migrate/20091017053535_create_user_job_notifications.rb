class CreateUserJobNotifications < ActiveRecord::Migration
  def self.up
    create_table :user_job_notifications do |t|
      t.integer :user_id, :job_log_id
      t.boolean :notified, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :user_job_notifications
  end
end
