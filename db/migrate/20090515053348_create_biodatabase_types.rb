class CreateBiodatabaseTypes < ActiveRecord::Migration
  def self.up
    create_table :biodatabase_types do |t|
      t.string "name",        :limit => 128, :null => false
      t.timestamps
    end
    BiodatabaseType.create(:name => BiodatabaseType::UPLOADED_RAW)
    BiodatabaseType.create(:name => BiodatabaseType::UPLOADED_CLEANED)
    BiodatabaseType.create(:name => BiodatabaseType::GENERATED_MASTER)
    BiodatabaseType.create(:name => BiodatabaseType::GENERATED_MATCH)
  end

  def self.down
    drop_table :biodatabase_types
  end

end
