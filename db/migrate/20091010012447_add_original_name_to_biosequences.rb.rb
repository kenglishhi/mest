class AddOriginalNameToBiosequences < ActiveRecord::Migration
  def self.up
    add_column :biosequences, :original_name, :string
  end

  def self.down
    remove_column :biosequences, :original_name
  end
end
