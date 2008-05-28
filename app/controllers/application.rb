# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'ftools'
require 'RMagick'
require 'digest/sha1'
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'b5d8f1af109a7e17c969d221dcfdf677'

  helper_method :current_user, :is_admin?

  protected

  # if current user is administrator then return user else redirect to admin/users/index
  def find_admin
    # role is 1 if user is administrator else role is 2 
    admin = current_user if current_user.role == 1 
    unless admin
      flash[:msg] = "You are not an administrator"
      redirect_to admin_users_url
    end
  end

  # returns current user
  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  # returns true if current user is administrator
  def is_admin?
    if current_user.role == 1
      true
    else
      false
    end
  end

  # checks is there any user logged in
  def find_user
    user=(User.find(session[:user_id]) rescue nil)
      unless user
      flash[:msg] = "Please log in"
      redirect_to new_session_path
    end
  end

end
