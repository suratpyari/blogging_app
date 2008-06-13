class Admin::UsersController < Admin::BaseController
  
  # Logged user must be an administrator for these actions
  before_filter :find_admin, :only => [:new, :create, :destroy]
  #skip_before_filter :find_user, :only => :show
  before_filter :validate_user, :only => [:show, :destroy]
  before_filter :validate_edit_user, :only => [:edit, :update]

  # Login is required for these actions

  #verify :method => :put, :only => [:update], :redirect_to => {:action => 'index'}
  #verify :method => :delete, :only => :destroy, :redirect_to => {:action => 'index'}

  # Lists all the users added by administrator and
  def index
    @users = User.find(:all)
  end

  # Shows details of a user
  def show
  end

  # New user
  def new
    @user=User.new
  end
  
  # Edits a user
  def edit
  end

  # Creates a new user and send a email to the user about his account.
  def create
    @user = User.new(params[:user])
    @user.username = params[:user][:username] 
    if @user.save 
      flash[:msg] = "New user created"
      email = AccountMailer.create_sent(@user)
      email.set_content_type("text/html" )
      AccountMailer.deliver(email)      
      redirect_to admin_user_path(@user)
    else # If new user is not created
      render :action => 'new'
    end   
  end

  # Updates user account
  def update
    if @user.update_attributes(params[:user])
      flash[:msg] = "username: #{@user.username} updated"
      redirect_to admin_user_path(@user)
    else # If user is not updated
      render :action => 'edit'
    end
  end

  # Destroy a user by administrator only ans shows the modified list of users (index)
  def destroy
    # Only administrator can destroy other user but also cannot destroy his self
    if is_admin? && @user != current_user
      @user.destroy
      flash[:msg] = "username: #{@user.username} deleted"
    else
      flash[:msg] = "You can not delete this user"
    end
    redirect_to admin_users_path
  end

  def cancel
    redirect_to admin_users_path
  end

  private

  # If user with given id is editable by current user then returns user and if
  # user with given id does not exists or current user is not an administrator then
  # redirects to admin/users/index
  def validate_edit_user
    @user = (User.find(params[:id]) rescue nil)
    if @user == current_user || is_admin?
      @user
    else
      flash[:msg] = "You cannot edit this user"
      redirect_to admin_users_path
    end
  end

end
