class CreateBiodatabaseLinkTypes < ActiveRecord::Migration
  def self.up
    create_table :biodatabase_link_types do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    BiodatabaseLinkType.create(:name => BiodatabaseLinkType::CLEANED)
  end

  def self.down
    drop_table :biodatabase_link_types
  end
end
