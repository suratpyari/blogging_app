# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'ftools'
require 'RMagick'
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'b5d8f1af109a7e17c969d221dcfdf677'

  helper_method :current_user

  protected

  def find_admin
    admin=(User.find_by id_and_role(session[:user_id],1) rescue nil)
    if !admin
      flash[:notice] = "You are not an admin user"
      redirect_to users_url
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def find_user
    user=(User.find(session[:user_id]) rescue nil)
      unless user
      flash[:notice] = "Please log in"
      redirect_to(:controller => "users" , :action => "login" )
    end
  end

end
