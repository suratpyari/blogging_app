class PostsController < ApplicationController

  # Login is required except these actions
  before_filter :verify_post, :only => :show

  # Lists the posts  
  def index
    # When no user is logged in,
    # lists only those post which are published
    # and status is 1 for published and 0 for unpublished posts.
    if !session[:user_id]
      @posts = Post.paginate :page => params[:page], :conditions => 'status = 1'
    # When current user is an administrator then lists all the posts
    # else lists only those posts which are either published or created by current user
    else if is_admin?
      @posts = Post.paginate :page => params[:page]
      else
        @posts = Post.paginate :page => params[:page], :conditions => ['status = 1 or user_id = ?', current_user.id]
      end
    end
  end

  # display selected post and comments given on that
  def show
    if session[:user_id] && (is_admin? || @post.user.id == current_user.id)
      @comments = @post.comments
      @change_status = true
    else if @post.status == 0
      flash[:msg] = "This poat is Unpublished"
      redirect_to posts_path
      else
        @comments = Comment.find_all_by_commentable_id_and_commentable_type_and_status(@post.id, "post", 1)
      end
    end
    @comment = @post.comments.new
  end

end
