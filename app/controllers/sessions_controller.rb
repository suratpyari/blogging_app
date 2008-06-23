class SessionsController < ApplicationController

  skip_before_filter :delete_method

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
      flash[:msg] = user ? "You cannot login. Your account id disabled. Please contact to administrator" : "Invalid user/password combination"
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
