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

  helper_method :current_user

  protected

  def find_admin
    admin = User.find_by_id_and_role(session[:user_id],1)
    unless admin
      flash[:msg] = "You are not an administrator"
      redirect_to admin_users_url
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def find_user
    user=(User.find(session[:user_id]) rescue nil)
      unless user
      flash[:msg] = "Please log in"
      redirect_to new_session_path
    end
  end

end
