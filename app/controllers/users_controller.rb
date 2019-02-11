class UsersController < ApplicationController
  def manage
    if current_user.admin?
      @users = User.vendor
    else
      redirect_to root_path, notice: I18n.t('users.messages.unauthorized')
    end
  end

  def deactivate
    @user = User.find(params[:id])
    @user.inactive!
    flash[:notice] = I18n.t('users.messages.inactive_user', email: @user.email)
    redirect_to manage_users_path
  end
end
