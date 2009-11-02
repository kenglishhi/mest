class CreateAlignments < ActiveRecord::Migration
  def self.up
    create_table :alignments do |t|
      t.string :label
      t.integer :fasta_file_id
      t.string  :aln_file_name, :aln_content_type
      t.integer :aln_file_size
      t.integer :project_id, :null => false
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :alignments
  end
end
