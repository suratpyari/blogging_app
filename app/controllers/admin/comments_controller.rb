class Admin::CommentsController < Admin::BaseController

  before_filter :delete_method, :only => :destroy
  before_filter :find_comment, :only => [:accept, :destroy]
  before_filter :verify_user, :only => [:accept, :destroy]

  # Accepts comment
  def index
    @post = Post.find(params[:post_id])
  end

  def accept
    @comment.update_attribute('status', 1)
    render :update do |page|
      page.replace_html 'status-'+comment.id.to_s, ''
    end
  end

  # Destroy comment 
  def destroy
    if @comment.destroy
      redirect_to admin_post_comments_path(@comment.commentable)
    end
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
    if @comment.commentable.user != current_user && !is_admin?
      redirect_to dashboard_path
    end
  end

end
