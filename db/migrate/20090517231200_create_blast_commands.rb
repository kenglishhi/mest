class CreateBlastCommands < ActiveRecord::Migration
  def self.up
    create_table :blast_commands do |t|
      t.integer :query_fasta_file_id, :db_fasta_file_id
      t.float   :evalue
      t.integer :identity, :score
      t.string  :fasta_file_prefix 
      t.string  :output_file_name, :output_content_type
      t.integer :output_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :blast_commands
  end
end
