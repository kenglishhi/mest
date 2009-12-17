class AddBiodatabaseIdToBlastResults < ActiveRecord::Migration
  def self.up
    add_column :blast_results, :test_biodatabase_id, :integer
    add_column :blast_results, :output_biodatabase_id, :integer
  end

  def self.down
    remove_column :blast_results, :test_biodatabase_id
#    remove_column :blast_results, :output_biodatabase_id
  end
end
