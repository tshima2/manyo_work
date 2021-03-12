class UsersController < ApplicationController

  before_action :do_auth, only:[:show]
  def new
    @user=User.new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      session[:user_id]=@user.id
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      redirect_to edit_user_path, notice: t('users.msg_update_success')
    else
      notice = t('users.msg_update_failed')
      render :edit
    end
  end

  def show
    @user=User.find(params[:id])
    if @current_user.id != @user.id
      flash[:danger] = t('notice.other_users_mypage')
      redirect_to tasks_path
    end
  end

  def destroy
    @user=User.find(params[:id])
    if @user.destroy
      notice=t('users.msg_destroy_success')
    else
      notice=t('users.msg_destroy_failed')
    end
    redirect_to users_path, notice: notice
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  def set_user
    @user=User.find(params[:id])    
  end
  def do_auth
    authenticate_user
  end
  
end

