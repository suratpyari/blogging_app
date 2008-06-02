# == Schema Information
# Schema version: 11
#
# Table name: posts
#
#  id         :integer(11)     not null, primary key
#  title      :string(255)     
#  content    :text            
#  user_id    :integer(11)     
#  status     :integer(11)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Post < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments, :as => :commentable
  has_many :visible_post_comments, :class_name => 'Comment' , :conditions => 'commentable_type = post and status = 1'

  validates_presence_of :title, :content
  validates_uniqueness_of :title

  STATUS = [["Unpublished", 0],["Published", 1]]

end
