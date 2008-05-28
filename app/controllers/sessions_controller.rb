class SessionsController < ApplicationController
  
  before_filter :find_user, :only => 'logout'

  def new
    redirect_to admin_users_url if session[:user_id]
  end

  # status is 0 if user is enabled and 1 if disabled
  # creates a new session
  def create
    user = User.authenticate(params[:username], params[:password])
    if user && user.status == 0
      session[:user_id] = user.id
      redirect_to posts_path
    else
      flash.now[:msg] = "You cannot login. Your account id disabled. Please contact to administrator" if user
      flash.now[:msg] = "Invalid user/password combination" if !user
      render :action => 'new'
    end
  end

  # deletes the session
  def destroy
    reset_session
    flash[:msg] = "Thanks for your visit"
    redirect_to new_session_url
  end

end
