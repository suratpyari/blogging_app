class Admin::PostsController < Admin::BaseController
  
  before_filter :find_user, :only => [:new, :create]
  before_filter :validate_user, :only => [:edit, :update, :destroy]
  

#  verify :method => :post, :only => :create, :redirect_to => 'dashboard'
#  verify :method => :put, :only => :update, :redirect_to => 'dashboard'
#  verify :method => :delete, :only => :destroy, :redirect_to => 'dashboard'

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
      render :action => :new
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
    redirect_to "/"
  end
  
  def edit
  end

  # updates the post
  def update
    if @post.update_attributes(params[:post])
      @post.categories << Category.find_by_category_name('Uncategorized') if @post.categories.empty?
      @post.save
      flash[:msg] = "Post updated"
      redirect_to post_path(@post)
    else
      render :action => :Edit
    end
  end

  def cancel
    redirect_to admin_posts_path
  end

  private 

  def validate_user
    verify_post
    if current_user != @post.user && !is_admin?
      flash[:msg] = 'You can not edit/ destroy this post as it is not created by you'
      redirect_to post_path(@post)
    end
    @post
  end

end
