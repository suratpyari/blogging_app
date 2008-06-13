class Admin::PostsController < Admin::BaseController
 

  before_filter :verify_post, :except => [:new, :create, :cancel, :index, :validate_user]
  before_filter :validate_user, :except => [:new, :create, :cancel, :index]

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
    @post.destroy
    flash[:msg] = "#{@post.title} deleted"
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
      render :action => 'edit'
    end
  end

  def cancel
    redirect_to admin_posts_path
  end

  private 

  def validate_user
    if current_user != @post.user && !is_admin?
      flash[:msg] = 'You can not edit/ destroy this post as it is not created by you'
      redirect_to post_path(@post)
    else
      @post
    end
  end

end
