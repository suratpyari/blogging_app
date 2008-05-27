class CategoriesPosts < ActiveRecord::Migration
  def self.up
    create_table :categories_posts, :id => false do |t|
      t.column :category_id, :integer
      t.column :post_id, :integer
    end
  end

  def self.down
    drop_table :categories_posts
  end
end
