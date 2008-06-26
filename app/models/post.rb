# == Schema Information
# Schema version: 16
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
#  version    :integer(11)     
#

class Post < ActiveRecord::Base

  acts_as_versioned
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :accepted_comments, :class_name => 'Comment', :conditions => "status = 1", :foreign_key => 'commentable_id'
  
  cattr_reader :per_page
  @@per_page = 2

  validates_presence_of :title, :content
  validates_uniqueness_of :title

  STATUS = [["Unpublished", 0],["Published", 1]]

  def self.published
    find(:all, :conditions => ["status = 1"])
  end
  
  def self.unpublished
    find(:all, :conditions => ["status = 0"])
  end
  
  def before_destroy
    self.taggings.each{|tagging| tagging.destroy}
  end

end
