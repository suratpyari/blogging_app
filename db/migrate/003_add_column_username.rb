class AddColumnUsername < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
  end

  def self.down
    remove_column :user, :username
  end
end
