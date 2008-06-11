# == Schema Information
# Schema version: 13
#
# Table name: comments
#
#  id               :integer(11)     not null, primary key
#  content          :string(255)     
#  author           :string(255)     
#  author_url       :string(255)     
#  email            :string(255)     
#  commentable_type :string(255)     
#  commentable_id   :integer(11)     
#  status           :integer(11)     default(0)
#  created_at       :datetime        
#  updated_at       :datetime        
#

class Comment < ActiveRecord::Base

  belongs_to :commentable, :polymorphic => true
  
  attr_protected :status
  validates_presence_of :content, :author, :email
  validates_format_of :email, :with => %r{^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$}, :if => Proc.new{|comment| comment.email && !comment.email.empty?}

  def comment_status
    if self.status == 0
      'Accept'
    else
      self.status == 2 ? 'Not spam':''
    end
  end

  def after_create
    self.update_attribute('status', 2) if check_comment_for_spam(self.author, self.content)
  end

  protected

  def check_comment_for_spam(author, text)
    @akismet = Akismet.new('a11d50c9d2ef', 'suratpyari.wordpress.com') 

    return true unless @akismet.verifyAPIKey 
       
    return @akismet.commentCheck(request.remote_ip,
                                 request.user_agent,
                                 request.env['HTTP_REFERER'],
                                 '',
                                 'comment',
                                 author,
                                 '',
                                 '',
                                 text,
                                 {})
  end

end
