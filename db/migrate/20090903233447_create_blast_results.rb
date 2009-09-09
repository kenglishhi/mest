class CreateBlastResults < ActiveRecord::Migration
  def self.up
    create_table :blast_results do |t|
      t.string :title, :job_log_id
      t.string  :output_file_name, :output_content_type
      t.integer :output_file_size
      t.datetime :job_start_time, :job_end_time
      t.integer :execution_time_msec
      t.timestamps
    end
  end

  def self.down
    drop_table :blast_results
  end
end
