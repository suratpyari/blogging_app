class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :title, :string
      t.column :content, :text
      t.column :user_id, :integer
      t.column :status, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
