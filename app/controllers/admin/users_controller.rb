class Admin::UsersController < Admin::BaseController

  
  before_filter :find_admin, :only => ['new', 'create', 'destroy']

  before_filter :find_user, :only => ['index', 'show', 'edit', 'update']

  def index
    @users = User.find(:all)
  end

  def show
    @user = validate_user
  end

  def new
    @user = User.new
  end
  
  def edit
    @user = validate_edit_user
  end

  def create
    @user = User.new(params[:user])
    @user.username = params[:user][:username]
    if @user.save 
      flash[:msg] = "New user created"
      email = AccountMailer.create_sent(@user)
      email.set_content_type("text/html" )
      AccountMailer.deliver(email)      
      redirect_to admin_user_path(@user)
    else
      render :action => 'new'
    end   
  end

  def update
    @user = validate_edit_user
    if @user.update_attributes(params[:user])
      flash[:msg] = "username: #{@user.username} updated"
      redirect_to admin_user_path(@user)
    else
      render :action => 'Edit'
    end
  end

  def destroy
    @user = validate_user
    if current_user.role == 1 && @user != current_user
      @user.destroy
      flash[:msg] = "username: #{@user.username} deleted"
    else
      flash[:msg] = "You can not delete this user"
    end
    redirect_to admin_users_path
  end

  def forgot_password
  end

  def send_email
    user = User.find_by_email(params[:email])
    if user
      user.update_attribute('token',Digest::SHA1.hexdigest(rand.to_s))
      url = edit_password_admin_users_path(:token => user.token, :only_path => false)
      email = PasswordMailer.create_sent(user, url)
      email.set_content_type("text/html" )
      PasswordMailer.deliver(email)
      redirect_to new_session_path
    else
      flash[:msg] = "user with this email does not exist"
      render :action => 'forgot_password'
    end
  end

  def edit_password
    @user = User.find_by_token(params[:token])
  end

  def update_password
    @user = User.find_by_token(params[:token])
    if @user.update_attributes(params[:user])
      flash[:msg] = "password updated"
      redirect_to new_session_path
    else
      render :action => 'edit_password'
    end
  end

  private

  def validate_user
    user = (User.find(params[:id]) rescue nil)
    if user.nil?
      flash[:msg] = "User with id #{params[:id]} does not exist"
      redirect_to admin_users_path
    else
      return user
    end
  end

  def validate_edit_user
    user = (User.find(params[:id]) rescue nil)
    if (user.nil? || user.id != current_user.id)&&( current_user.role != 1)
      flash[:msg] = "You cannot edit this user"
      redirect_to admin_users_path
    else
      return user
    end
  end

end
