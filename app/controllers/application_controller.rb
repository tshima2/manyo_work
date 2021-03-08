class ApplicationController < ActionController::Base
  #before_action :basic_auth
  protect_from_forgery with: :exception
  include SessionsHelper
  

  private
  def authenticate_user
    # 現在ログイン中のユーザが存在しない場合、ログインページにリダイレクトする
    current_user
    redirect_to new_sessions_path, notice: t('notice.login_needed') unless @current_user
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end
