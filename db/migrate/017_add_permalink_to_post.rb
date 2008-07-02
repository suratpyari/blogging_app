class AddPermalinkToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :parmalink, :string
    add_column :post_versions, :parmalink, :string
  end

  def self.down
    remove_column :posts, :parmalink
    remove_column :post_versions, :parmalink
  end
end
