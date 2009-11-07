class CreateFastaFiles < ActiveRecord::Migration
  def self.up
    create_table :fasta_files do |t|
      t.string :label
      t.string  :fasta_file_name, :fasta_content_type
      t.integer :fasta_file_size
      t.boolean :is_generated, :default => false
      t.integer :project_id, :null => false
      t.integer :user_id
      t.timestamps
    end

  end

  def self.down
    drop_table :fasta_files
  end
end
