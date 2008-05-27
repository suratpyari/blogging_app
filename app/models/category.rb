class Category < ActiveRecord::Base

  has_and_belongs_to_many :posts

  validates_presence_of :category_name
  validates_uniqueness_of :category_name

end
