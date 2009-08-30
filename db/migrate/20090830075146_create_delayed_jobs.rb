class CreateDelayedJobs < ActiveRecord::Migration
  def self.up
    create_table "delayed_jobs", :force => true do |t|
      t.string   "job_name"
      t.integer  "priority",      :default => 0
      t.integer  "attempts",      :default => 0
      t.text     "handler"
      t.text     "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string   "locked_by"
      t.boolean  "run_once"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :delayed_jobs
  end
end
