class UsersController < ApplicationController
  before_action :authenticate_user!

  def manage
    if current_user.admin?
      @users = User.vendor
    else
      redirect_to root_path, notice: I18n.t('users.messages.unauthorized')
    end
  end

  def deactivate
    if current_user.admin?
      @user = User.find(params[:id])
      @user.inactive!
      flash[:notice] = I18n.t('users.messages.inactive_user',
                              email: @user.email)
      redirect_to manage_users_path
    else
      redirect_to root_path, notice: I18n.t('users.messages.unauthorized')
    end
  end
end
