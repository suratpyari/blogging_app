class UsersController < ApplicationController

  layout :determine_layout

  def show
    @user=User.find_by_username(params[:id])
  end

end
