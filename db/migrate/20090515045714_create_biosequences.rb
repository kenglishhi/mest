class CreateBiosequences < ActiveRecord::Migration
  def self.up
    create_table :biosequences do |t|
      t.string  "name",  :null => false
      t.text    "description"
      t.integer "length"
      t.string  "alphabet", :limit => 10
      t.text    "seq",      :limit => 2147483647
    end

    add_index :biosequences , :name, :unique => true
  end

  def self.down
    drop_table :biosequences
  end
end
