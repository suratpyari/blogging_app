class UsersController < ApplicationController

  
  def show
    @user=User.find_by_username(params[:id])
    render :partial => 'admin/users/profile'
  end

end
