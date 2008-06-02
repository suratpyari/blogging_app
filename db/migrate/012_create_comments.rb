class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :content, :string
      t.column :author, :string
      t.column :author_url, :string
      t.column :email, :string
      t.column :commentable_type, :string
      t.column :commentable_id, :integer
      t.column :status, :integer, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
