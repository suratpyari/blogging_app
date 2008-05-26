class Admin::UsersController < Admin::BaseController

  
  before_filter :find_admin, :except => ['index', 'show']

  before_filter :find_user, :only => ['index', 'show']

  def index
    @users=User.find(:all)
  end

  def show
    @user=validate_user
  end

  def new
    @user=User.new
  end
  
  def edit
    @user=validate_user
  end

  def create
    @user = User.new(params[:user])
    @user.username=params[:user][:username]
    if @user.save 
      flash[:msg] = "New user created"
      redirect_to admin_user_path(@user)
    else
      render :action => 'new'
    end   
  end

  def update
    @user=validate_user
    if @user.update_attributes(params[:user])
      flash[:msg]="user updated"
      redirect_to admin_user_path(@user)
    else
      render :action => 'new'
    end
  end

  def destroy
    @user=validate_user
    if current_user.role==1 && @user != current_user
      @user.destroy
      flash[:msg]="user is deleted"
    else
      flash[:msg] = "can not delete"
    end
    redirect_to admin_users_path
  end

  private

  def validate_user
    user=(User.find(params[:id]) rescue nil)
    if user.nil?
      flash[:msg] = "User does not exists"
      redirect_to admin_users_path
    else
      return user
    end
  end

end
