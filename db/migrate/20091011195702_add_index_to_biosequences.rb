class AddIndexToBiosequences < ActiveRecord::Migration
  def self.up
    add_index :biosequences, :name
  end

  def self.down
  end
end
