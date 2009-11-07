class CreateBlastResults < ActiveRecord::Migration
  def self.up
    create_table :blast_results do |t|
      t.string :name 
      t.string  :output_file_name, :output_content_type
      t.integer :output_file_size
      t.datetime :started_at, :stopped_at
      t.decimal  :duration_in_seconds, :scale => 4, :precision => 10
      t.integer :user_id
      t.integer :project_id
      t.text :command
      t.timestamps
    end
  end

  def self.down
    drop_table :blast_results
  end
end
