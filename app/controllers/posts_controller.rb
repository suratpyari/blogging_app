class PostsController < ApplicationController

  before_filter :find_user, :only => [:new, :create]
  before_filter :verify_post, :only => [:show, :edit, :update, :destroy]
  
  def index
    if current_user.role == 1
      @posts = Post.find(:all)
    else
      @posts = Post.find_all_by_status(1)
    end
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post=Post.new(params[:post])
    @post.user_id = current_user.id
    if @post.categories.empty?
      @post.categories << Category.find_by_category_name('Uncategorized')
    end
    if @post.save
      flash[:msg] = "new post created"
      redirect_to post_path(@post)
    else
      flash[:msg] = "new post not created"
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(params[:post])
      if @post.categories.empty?
        @post.categories << Category.find_by_category_name('Uncategorized')
      end
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
      redirect_to posts_path :id => current_user.id
    end
  end

end
