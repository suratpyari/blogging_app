class PostsController < ApplicationController

  before_filter :verify_post, :only => :show

  # Lists the posts  
  def index
      @posts = Post.paginate :page => params[:page], :conditions => 'status = 1'
  end

  # display selected post and comments given on that
  def show
    if @post.status == 0
      flash[:msg] = "This post is Unpublished"
      redirect_to "/"
    else
      @comment = Comment.new
    end
  end

end
