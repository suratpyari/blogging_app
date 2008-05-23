class Admin::UsersController < Admin::BaseController

  
  before_filter :find_admin, :except => ['index', 'show']

  before_filter :find_user, :only => ['index', 'show']

  def index
    @users=User.find(:all)
  end

  def show
    @user=User.find(params[:id]) rescue nil
  end

  def new
    @user=User.new
  end
  
  def edit
    @user=User.find(params[:id].to_i) rescue nil
  end

  def create
    @user = User.new(params[:user])
    @user.username=params[:user][:username]
    if @user.save 
      flash[:notice] = "New user created"
      redirect_to admin_user_path(@user)
    else
      flash[:msg]=@user.errors.full_messages.join("<br />")
      render :action => 'new'
    end   
  end

  def update
    @user=User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:msg]="user updated"
      redirect_to admin_user_path(@user)
    else
      flash[:msg]=@user.errors.full_messages.join("<br />")
      render :action => 'new'
    end
  end

  def destroy
    @user=User.find(params[:id]) rescue nil
    if current_user.role==1 && @user != current_user
      @user.destroy
      flash[:msg]="user is deleted"
    else
      flash[:msg] = "can not delete"
    end
    redirect_to admin_users_path
  end

end
