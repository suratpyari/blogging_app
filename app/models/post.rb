# == Schema Information
# Schema version: 13
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

  cattr_reader :per_page
  @@per_page = 2

  validates_presence_of :title, :content
  validates_uniqueness_of :title

  STATUS = [["Unpublished", 0],["Published", 1]]

  def accepted_comments
    @comments = self.comments.find_by_status(1)
    if @comments.nil?
      @comment = [];
    end
    @comments
  end

  def before_destroy
    for comment in self.comments
      comment.destroy
    end
    for tag in self.tags
      if tag.posts.size < 2
        tag.destroy
      end
    end
  end

end
