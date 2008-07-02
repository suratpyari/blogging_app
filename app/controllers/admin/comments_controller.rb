class Admin::CommentsController < Admin::BaseController

  before_filter :delete_method, :only => :destroy
  before_filter :find_comment, :only => [:accept, :destroy]
  before_filter :verify_user, :only => [:accept, :destroy]

  # lists all the comments having status = 0 or 2
  def recent_comments
    @comments = []
    comments = Comment.find(:all)
    comments.each{|comment| @comments << comment if comment.status != 1 && (is_admin? || comment.commentable.user == current_user)}
  end  

  # Accepts comment

  def accept
    @comment.update_attribute('status', 1)
    render :update do |page|
      page.replace_html 'status-'+@comment.id.to_s, ''
    end
  end

  # Destroy comment 
  def destroy
    @comment.destroy
    redirect_to recent_comments_path
  end

  private

  def find_comment
    @comment = Comment.find(params[:id]) rescue nil
    if @comment.nil?
      flash[:msg] = "This comment does not exists"
      redirect_to dashboard_path
    end
  end

  def verify_user
      redirect_to dashboard_path if @comment.commentable.user != current_user && !is_admin?
  end

end
