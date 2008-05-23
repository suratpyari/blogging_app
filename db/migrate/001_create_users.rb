class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email, :string
      t.column :hashed_password, :string
      t.column :salt, :string
      t.column :role, :integer, :default => 2, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
