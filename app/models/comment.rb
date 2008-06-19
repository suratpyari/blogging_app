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
  #before_create :check_for_spam
  
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

  protected
  
  def request=(request)
   self.user_ip    = request.remote_ip
   self.user_agent = request.env['HTTP_USER_AGENT']
   self.referrer   = request.env['HTTP_REFERER']
  end

#  def check_for_spam
#   Akismetor.spam?(akismet_attributes(self.author, self.content)) ? self.status = 2 : self.status = 0
#   true # return true so it doesn't stop save
#  end

#  def akismet_attributes(author, text)
#   {
#     :key              => 'a11d50c9d2ef',
#     :blog             => 'suratpyari.wordpress.com',
#     :user_ip          =>  user_ip,
#     :user_agent       =>  user_agent,
#     :comment_author   => author,
#     :comment_content  => text
#   }
#  end

#  attr_accessor :user_ip, :user_agent, :referrer

end
