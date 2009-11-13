class AddNrSequenceFlagToBiosequences < ActiveRecord::Migration
  def self.up
    add_column :biosequences, :nr_sequence_flag, :boolean, :default => 0
  end


  def self.down
    remove_column :biosequences, :nr_sequence_flag
  end
end
