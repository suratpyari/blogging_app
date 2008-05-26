class SessionsController < ApplicationController
  
  before_filter :find_user, :only => 'logout'

  def new
    redirect_to admin_users_url if session[:user_id]
  end

  #status 0 if user is enabled and 1 if disabled
  def create
    user = User.authenticate(params[:username], params[:password])
    if user && user.status==0
      session[:user_id] = user.id
      redirect_to admin_users_url
    else
      flash.now[:msg] = "You cannot login" if user
      flash.now[:msg] = "Invalid user/password combination" if !user
      render :action => 'new'
    end
  end

  def destroy
    reset_session
    flash[:msg]="Thanks for your visit"
    redirect_to new_session_url
  end

end
