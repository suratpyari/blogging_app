class UsersController < ApplicationController

  before_filter :is_user, :only => :show

  def show
    render :partial => 'admin/users/profile', :layout => 'application'
  end
  
  # Sends an Email with a token when a user forgets his password so that he can update
  # his password and redirect to login screen
  def send_email
    user = User.find_by_email(params[:email])
    if user
      p "1"
      user.update_attribute('token',Digest::SHA1.hexdigest(rand.to_s)) # Token saved
      # Generates a url where user can edit his password
      url = edit_password_users_path(:token => user.token, :only_path => false) 
      email = PasswordMailer.create_sent(user, url)
      email.set_content_type("text/html" )
      PasswordMailer.deliver(email)
      flash[:msg] = "An email has been sent"
      redirect_to login_path
    else # When email address given by user does not exists
      flash.now[:msg] = "user with this email does not exist"
      render :action => 'forgot_password', :layout => 'application'
    end
  end
  
  def forgot_password
    render :layout => 'application'
  end

  # Edits the password
  def edit_password
    @user = User.find_by_token(params[:token])
    if @user
      render :layout => 'application'
    else
      flash[:msg] = "wrong token"
      redirect_to login_path
    end
  end

  # Updates the password
  def update_password
    @user = User.find_by_token(params[:token])
    if @user.update_attributes(params[:user])
      flash[:msg] = "password updated"
      @user.update_attribute('token', nil)
      redirect_to login_path
    else # If not modified
      render :action => 'edit_password'
    end
  end
  
  private

  def is_user
    @user = (User.find_by_username(params[:id]) rescue nil)
    if @user.nil?
      flash[:msg] = "User with id #{params[:id]} does not exist"
      redirect_to posts_path
    end
  end

end
