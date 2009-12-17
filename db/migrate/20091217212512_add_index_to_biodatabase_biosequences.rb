class AddIndexToBiodatabaseBiosequences < ActiveRecord::Migration
  def self.up
    add_index :biodatabase_biosequences, :biosequence_id
  end

  def self.down
  end
end
