class AddIndexBiodatabaseIdToBiodatabaseBiosequences < ActiveRecord::Migration
  def self.up
    add_index :biodatabase_biosequences, :biodatabase_id
  end

  def self.down
  end
end
