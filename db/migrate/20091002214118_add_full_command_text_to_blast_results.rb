class AddFullCommandTextToBlastResults < ActiveRecord::Migration
  def self.up
    add_column :blast_results, :command, :text

  end

  def self.down
    remove_column :blast_results, :command
  end
end
