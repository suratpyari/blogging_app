class Admin::BaseController < ApplicationController

  protected

  def find_admin
    if current_user.role == 1
      @admin=current_user
    else
      redirect_to users_path
    end
  end

end
