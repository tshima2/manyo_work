class Admin::UsersController < ApplicationController
  include SessionsHelper
  
  before_action :check_user, only: [:index, :show]
#  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index
    @users=User.all.order(created_at: :asc)
  end

  def new
    @user=User.new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user.id), notice: t('admin.msg_user_create_success.')
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
      redirect_to admin_user_path(@user.id), notice: t('admin.msg_user_update_sccess.')
    else
      notice = t('admin.msg_user_update_failed')
      render :edit
    end
  end

  def show
    @user=User.find(params[:id])
  end

  def destroy
    @user=User.find(params[:id])
    if @user.destroy
      notice=t('admin.msg_users_destroy_success')
    else
      notice=t('admin.msg_users_destroy_failed')
    end
    redirect_to admin_users_path, notice: notice
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user=User.find(params[:id])
  end

  def check_user
    redirect_to tasks_path, notice: t('application.msg_admin_priv_denied_to_access') unless admin?
  end
end
