class Admin::UsersController < Admin::BaseController
  
  layout 'admin'
  # Logged user must be an administrator for these actions
  before_filter :find_admin, :only => ['new', 'create', 'destroy'] 

  before_filter :find_user, :only => ['index', 'show', 'edit', 'update'] # Login is required for these actions

  # Lists all the users added by administrator and
  def index
    @users = User.find(:all)
  end

  # Shows details of a user
  def show
    @user = validate_user
  end

  # New user
  def new
    @user = User.new
  end
  
  # Edits a user
  def edit
    @user = validate_edit_user
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
    @user = validate_edit_user
    if @user.update_attributes(params[:user])
      flash[:msg] = "username: #{@user.username} updated"
      redirect_to admin_user_path(@user)
    else # If user is not updated
      render :action => 'edit'
    end
  end

  # Destroy a user by administrator only ans shows the modified list of users (index)
  def destroy
    @user = validate_user
    # Only administrator can destroy other user but also cannot destroy his self
    if is_admin? && @user != current_user
      @user.destroy
      flash[:msg] = "username: #{@user.username} deleted"
    else
      flash[:msg] = "You can not delete this user"
    end
    redirect_to admin_users_path
  end

  # Sends an Email with a token when a user forgets his password so that he can update
  # his password and redirect to login screen
  def send_email
    user = User.find_by_email(params[:email])
    if user
      user.update_attribute('token',Digest::SHA1.hexdigest(rand.to_s)) # Token saved
      # Generates a url where user can edit his password
      url = edit_password_admin_users_path(:token => user.token, :only_path => false) 
      email = PasswordMailer.create_sent(user, url)
      email.set_content_type("text/html" )
      PasswordMailer.deliver(email)
      redirect_to new_session_path
    else # When email address given by user does not exists
      flash[:msg] = "user with this email does not exist"
      render :action => 'forgot_password'
    end
  end

  # Edits the password
  def edit_password
    @user = User.find_by_token(params[:token])
  end

  # Updates the password
  def update_password
    @user = User.find_by_token(params[:token])
    if @user.update_attributes(params[:user])
      flash[:msg] = "password updated"
      redirect_to new_session_path
    else # If not modified
      render :action => 'edit_password'
    end
  end

  private

  # If user with given id exists it returns user of that id else redirects to
  # admin/users/index
  def validate_user
    user = (User.find(params[:id]) rescue nil)
    if user.nil?
      flash[:msg] = "User with id #{params[:id]} does not exist"
      redirect_to admin_users_path
    else
      return user
    end
  end

  # If user with given id is editable by current user then returns user and if
  # user with given id does not exists or current user is not an administrator then
  # redirects to admin/users/index
  def validate_edit_user
    user = (User.find(params[:id]) rescue nil)
    if (user.nil?)&&( !is_admin?)
      flash[:msg] = "You cannot edit this user"
      redirect_to admin_users_path
    else
      return user
    end
  end

end
