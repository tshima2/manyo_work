class SessionsController < ApplicationController
  def new
    user = User.new
  end

  def create
    user=User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to user_path(user.id), notice: t('application.msg_login_success')
    else
      #render :new
      redirect_to new_user_path, notice: t('application.msg_login_failed')
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_sessions_path, notice: t('application.msg_logout_success')
  end
end
