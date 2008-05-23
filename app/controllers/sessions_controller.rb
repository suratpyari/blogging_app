class SessionsController < ApplicationController
  
  before_filter :find_user, :only => 'logout'

  def new
    if session[:user_id]
      redirect_to admin_users_url
    end
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user && user.status==0
      session[:user_id] = user.id
      redirect_to admin_users_url
    else
      flash.now[:msg] = "You can not login" if user
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
