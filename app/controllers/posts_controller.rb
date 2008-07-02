class PostsController < ApplicationController

  before_filter :verify_post_parmalink, :only => :show
  layout "application", :except => [:feed]

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

  def feed
    @posts = Post.find(:all, :limit => 10, :order => "created_at DESC", :conditions => "status = 1")
  end

end
