class Admin::PostsController < Admin::BaseController

  before_filter :verify_post, :only => [:edit, :update, :destroy, :version]
  before_filter :verify_post_parmalink, :only => [:show]
  before_filter :verify_user, :only => [:edit, :update, :destroy]
  
  def new
    @post = Post.new
  end

  def show
    if @post.status == 0 && @post.user != current_user && !is_admin?
      flash[:msg] = "This is an unpublished post"
      redirect_to admin_posts_path
    else
      render :partial => "posts/post", :layout => "admin"
    end
  end

  def version
    if @post.status == 0 && @post.user != current_user && !is_admin?
      flash[:msg] = "This is an unpublished post"
      redirect_to admin_posts_path
    else
      @post_v = @post.find_version(params[:version])
    end
  end

  # Lists the posts  
  def index
    # When current user is an administrator then lists all the posts
    # else lists only those posts which are either published or created by current user
    is_admin? ? @posts = Post.find(:all) : @posts = Post.find(:all, :conditions => ['status = 1 or user_id = ?', current_user.id])
  end

  # creates a new post
  def create
    @post = Post.new(params[:post])
    @post.parmalink = params[:post][:parmalink]
    @post.user_id = current_user.id
    # category of post is uncategorized if it is not set by user
    @post.categories << Category.find_by_category_name('Uncategorized') if @post.categories.empty?
    if @post.save
      @post.tag_with params[:tag][:name]
      flash[:msg] = "new post created"
      redirect_to admin_post_path(:action => "show", :slug => (@post.parmalink ? @post.parmalink : ""))
    else
      render :action => :new
    end
  end

  # destroy the post when either post is created by current user or user id an administrator
  # else redirects to posts/index
  def destroy
    @post.destroy
    flash[:msg] = "#{@post.title} deleted"
    redirect_to admin_posts_path
  end
  
  def edit
  end

  # updates the post
  def update
    if @post.update_attributes(params[:post])
      @post.categories << Category.find_by_category_name('Uncategorized') if @post.categories.empty?
      @post.save
      flash[:msg] = "Post updated"
      redirect_to admin_post_path(:action => "show", :slug => (@post.parmalink ? @post.parmalink : ""))
    else
      render :action => 'edit'
    end
  end

  def change_text_field
    render :update do |page|
      page.replace_html 'textareapostcontent', text_area(:post, :content, "value" => params[:content])
    end
  end

  private 

  def verify_user
    if current_user != @post.user && !is_admin?
      flash[:msg] = 'You can not edit/ destroy this post as it is not created by you'
      redirect_to admin_post_path(:action => "show", :slug => (@post.parmalink ? @post.parmalink : ""))
    end
  end

end
