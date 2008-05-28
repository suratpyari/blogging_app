class PostsController < ApplicationController

  before_filter :find_user, :except => [:index, :show] # login is required except these actions
  before_filter :verify_post, :only => [:show, :edit, :update, :destroy] 

  # lists the posts  
  def index
    # when no user is logged in,
    # lists only those post which are published
    # and status is 1 for published and 0 for unpublished posts.
    if !session[:user_id]
      @posts = Post.find_all_by_status(1)
    # when current user is an administrator then lists all the posts
    # else lists only those posts which are either published or created by current user
    else if is_admin?
      @posts = Post.find(:all)
      else
        @posts = (Post.find_all_by_status(1)+current_user.posts).uniq!
    end
    end
  end

  def show
  end

  def new
    @post = Post.new
  end

  # creates a new post
  def create
    @post=Post.new(params[:post])
    @post.user_id = current_user.id
    @post.categories << Category.find_by_category_name('Uncategorized') if @post.categories.empty?
    if @post.save
      flash[:msg] = "new post created"
      redirect_to post_path(@post)
    else
      flash[:msg] = "new post not created"
      render :action => 'new'
    end
  end

  
  def update
    if @post.update_attributes(params[:post])
      @post.categories << Category.find_by_category_name('Uncategorized') if @post.categories.empty?
      @post.save
      flash[:msg] = "Post updated"
      redirect_to post_path(@post)
    else
      flash[:msg] = "Post not updated"
      render :action => 'Edit'
    end
  end

  def destroy
    if @post.user_id == current_user.id
      @post.destroy
      flash[:msg] = "#{@post.title} deleted"
    else
      flash[:msg] = "Cannot delete this post. This is not created by you"
    end
    redirect_to posts_path :id => current_user.id
  end

  private

  def verify_post
    @post = (Post.find(params[:id]) rescue nil)
    if @post.nil?
      flash[:msg] = "Post with id #{params[:id]} does not exist"
      redirect_to posts_path
    end
  end

end
