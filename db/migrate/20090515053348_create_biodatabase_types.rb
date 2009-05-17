class CreateBiodatabaseTypes < ActiveRecord::Migration
  def self.up
    create_table :biodatabase_types do |t|
      t.string "name",        :limit => 128, :null => false
      t.timestamps
    end
    BiodatabaseType.create(:name => 'Raw')
    BiodatabaseType.create(:name => 'Clearned Stage 1')
    BiodatabaseType.create(:name => 'Clearned Stage 1')
  end

  def self.down
    drop_table :biodatabase_types
  end
end
