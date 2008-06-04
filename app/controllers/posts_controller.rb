class PostsController < ApplicationController

  layout :determine_layout

   # Login is required except these actions
  before_filter :find_user, :except => [:index, :show]

  before_filter :verify_post, :only => [:show, :edit, :update, :destroy]

  verify :method => :post, :only => :create, :redirect_to => {:action => 'index'}
  verify :method => :put, :only => :update, :redirect_to => {:action => 'index'}
  verify :method => :delete, :only => :destroy, :redirect_to => {:action => 'index'}

  cattr_reader :per_page
  @@per_page = 2

  # Lists the posts  
  def index
    # When no user is logged in,
    # lists only those post which are published
    # and status is 1 for published and 0 for unpublished posts.
    if !session[:user_id]
      @posts = Post.paginate :page => params[:page], :conditions => 'status = 1', :per_page => @@per_page
    # When current user is an administrator then lists all the posts
    # else lists only those posts which are either published or created by current user
    else if is_admin?
      @posts = Post.paginate :page => params[:page], :per_page => @@per_page
      else
        @posts = Post.paginate :page => params[:page], :conditions => ['status = 1 or user_id = ?', current_user.id] , :per_page => @@per_page
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

  def new
    @post = Post.new
  end

  # creates a new post
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id
    # category of post is uncategorized if it is not set by user
    @post.categories << Category.find_by_category_name('Uncategorized') if @post.categories.empty?
    if @post.save
      @post.tag_with params[:tag][:name]
      flash[:msg] = "new post created"
      redirect_to post_path(@post)
    else
      flash[:msg] = "new post not created"
      render :action => :new
    end
  end

  # updates the post
  def update
    if @post.update_attributes(params[:post])
      @post.categories << Category.find_by_category_name('Uncategorized') if @post.categories.empty?
      @post.save
      flash[:msg] = "Post updated"
      redirect_to post_path(@post)
    else
      flash[:msg] = "Post not updated"
      render :action => :Edit
    end
  end

  # destroy the post when either post is created by current user or user id an administrator
  # else redirects to posts/index
  def destroy
    if @post.user_id == current_user.id || is_admin?
      @post.destroy
      flash[:msg] = "#{@post.title} deleted"
    else
      flash[:msg] = "Cannot delete this post. This is not created by you"
    end
    redirect_to posts_path
  end

  private

  # if post with given id exists it returns post of that id else redirects to posts/index
  def verify_post
    @post = (Post.find(params[:id]) rescue nil)
    if @post.nil?
      flash[:msg] = "Post with this id does not exist"
      redirect_to posts_path
    end
  end

end
