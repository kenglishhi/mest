class AddBiodatabaseIdToBlastResults < ActiveRecord::Migration
  def self.up
    add_column :blast_results, :test_biodatabase_id, :integer
  end

  def self.down
  end
end
