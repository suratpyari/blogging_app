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

uses_tiny_mce(:options => {:theme => 'advanced',
                           :mode => "specific_textareas",
                           :editor_selector => "mce-editor",
                           :browsers => %w{msie gecko},
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_resizing => true,
                           :theme_advanced_resize_horizontal => false,
                           :paste_auto_cleanup_on_paste => true,
	                         :theme_advanced_buttons1 => %w{save newdocument | bold italic underline strikethrough | justifyleft justifycenter justifyright justifyfull | styleselect formatselect fontselect fontsizeselect},
	                         :theme_advanced_buttons2 => %w{ cut copy paste pastetext pasteword | search replace | bullist numlist | outdent indent blockquote | undo redo | link unlink anchor image cleanup help code | insertdate inserttime preview | forecolor backcolor},
	                         :theme_advanced_buttons3 => %w{tablecontrols | hr removeformat visualaid | sub sup | charmap emotions iespell media advhr | print | ltr rtl | fullscreen},
	                         #:theme_advanced_buttons4 =>%w{insertlayer moveforward movebackward absolute | styleprops | cite abbr acronym del ins attribs | visualchars nonbreaking template pagebreak},
                           :plugins => %w{contextmenu paste},
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_statusbar_location => "bottom",
	                         :theme_advanced_resizing => true})



  helper_method :current_user, :is_admin?

  protected

  # If current user is administrator then return user else redirect to admin/users/index
  def find_admin
    # Role is 1 if user is administrator else role is 2 
    admin = current_user if is_admin?
    unless admin
      flash[:msg] = "You are not an administrator"
      redirect_to dashboard_path
    end
  end

  # Returns current user
  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  # Returns true if current user is administrator
  def is_admin?
    current_user.role == 1
  end

  # checks is there any user logged in
  def find_user
      unless current_user
      flash[:msg] = "Please log in"
      redirect_to login_path
    end
  end

  # if post with given id exists it returns post of that id else redirects to posts/index
  def verify_post
    @post = (Post.find(params[:id]) rescue nil)
    if @post.nil?
      flash[:msg] = "Post with this id does not exist"
      redirect_to posts_path
    end
  end


end
