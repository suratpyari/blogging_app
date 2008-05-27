class Post < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :categories

  validates_presence_of :title, :content
  validates_uniqueness_of :title

  STATUS = [["Unpublished", 0],["Published", 1]]

end
