class AddBiodataInUser < ActiveRecord::Migration
  def self.up
    add_column :users, :biodata, :text
  end

  def self.down
    remove_column :users, :biodata
  end
end
