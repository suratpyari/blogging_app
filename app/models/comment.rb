class Comment < ActiveRecord::Base

  belongs_to :commentable, :polymorphic => true
  
  attr_protected :status
  validates_presence_of :content, :author, :email
  validates_format_of :email, :with => %r{^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$}

  def comment_status
    if self.status == 0 # rejected => 0 and accepted => 1
      'Accept'
    else
      ''
    end
  end

end
