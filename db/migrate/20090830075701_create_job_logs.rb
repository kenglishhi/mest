class CreateJobLogs < ActiveRecord::Migration
  def self.up
    create_table :job_logs do |t|
      t.string   :job_name
      t.string   :job_class_name
      t.datetime :started_at
      t.datetime :stopped_at
      t.decimal  :duration_in_seconds, :scale => 4, :precision => 10
      t.boolean  :success
      t.text     :message
      t.integer :user_id
      t.integer :project_id
    end

  end

  def self.down
  end
end
