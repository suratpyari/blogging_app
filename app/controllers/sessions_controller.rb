class SessionsController < ApplicationController

  def new
    redirect_to admin_users_url if session[:user_id]
  end

  # Status is 0 if user is enabled and 1 if disabled
  # Creates a new session
  def create
    user = User.authenticate(params[:username], params[:password])
    if user && user.status == 0
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:msg] = "You cannot login. Your account id disabled. Please contact to administrator" if user
      flash[:msg] = "Invalid user/password combination" if !user
      render :action => 'new'
    end
  end

  # Deletes the session
  def destroy
    reset_session
    flash[:msg] = "Thanks for your visit"
    redirect_to posts_path
  end

end
