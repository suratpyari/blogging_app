class AddColStatus < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :integer, :default => 0
  end

  def self.down
    remove_column :users, :status
  end
end
