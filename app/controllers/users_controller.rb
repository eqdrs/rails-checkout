class UsersController < ApplicationController
  def manage
    @users = User.vendor
  end

  def deactivate
    @user = User.find(params[:id])
    @user.inactive!
    flash[:notice] = I18n.t('users.messages.inactive_user', email: @user.email)
    redirect_to manage_users_path
  end
end