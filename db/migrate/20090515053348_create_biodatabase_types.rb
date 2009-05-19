class CreateBiodatabaseTypes < ActiveRecord::Migration
  def self.up
    create_table :biodatabase_types do |t|
      t.string "name",        :limit => 128, :null => false
      t.timestamps
    end
    BiodatabaseType.create(:name => 'UPLOADED-RAW')
    BiodatabaseType.create(:name => 'UPLOADED-CLEARNED')
    BiodatabaseType.create(:name => 'GENERATED-MASTER')
    BiodatabaseType.create(:name => 'GENERATED-MATCH')
  end

  def self.down
    drop_table :biodatabase_types
  end
end
