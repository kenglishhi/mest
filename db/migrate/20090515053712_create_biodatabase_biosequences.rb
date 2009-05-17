class CreateBiodatabaseBiosequences < ActiveRecord::Migration
  def self.up
    create_table :biodatabase_biosequences do |t|
      t.integer :biodatabase_id, :biosequence_id 
    end
  end

  def self.down
    drop_table :biodatabase_biosequences
  end
end
