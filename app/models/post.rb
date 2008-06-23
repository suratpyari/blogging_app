# == Schema Information
# Schema version: 15
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
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :accepted_comments, :class_name => 'Comment', :conditions => "status = 1", :foreign_key => 'commentable_id'
  
  cattr_reader :per_page
  @@per_page = 2

  validates_presence_of :title, :content
  validates_uniqueness_of :title

  STATUS = [["Unpublished", 0],["Published", 1]]

  def before_destroy
    self.taggings.each{|tagging| tagging.destroy}
  end

end
