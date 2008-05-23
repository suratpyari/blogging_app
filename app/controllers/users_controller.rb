class UsersController < ApplicationController

  before_filter :find_user

  def index
    @users=User.find(:all)
  end

  def show
    @user=User.find(params[:id]) rescue nil
  end

end
