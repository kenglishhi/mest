class AddAlignmentFlagToFastaFiles < ActiveRecord::Migration
  def self.up
    add_column :fasta_files, :alignment_flag, :boolean, :default => false
  end

  def self.down
    remove_column :fasta_files, :alignment_flag
  end
end
