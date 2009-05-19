class CreateBiodatabases < ActiveRecord::Migration
  def self.up
    create_table :biodatabases do |t|
      t.string :name,        :limit => 128, :null => false
      t.string :authority,   :limit => 128
      t.text   :description
      t.integer :biodatabase_type_id
      t.integer :fasta_file_id
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :biodatabases
  end
end
