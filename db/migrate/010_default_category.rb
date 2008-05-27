class DefaultCategory < ActiveRecord::Migration
  def self.up
    Category.create(:category_name => 'Uncategorized', :description => 'default category for post')
  end

  def self.down
    Category.destroy_all "category_name = 'Uncategorized'"
  end
end
