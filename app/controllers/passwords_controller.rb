class PasswordsController < ApplicationController
  def edit; end

  def update
    if current_user.update_with_password(user_params)
      flash[:notice] = 'Atualização de senha realizada com sucesso!'
    else
      flash[:error] = 'Atualização de senha falhou'
    end
    render :edit
  end

  private

  def user_params
    params.require(:user).permit(:current_password, :password,
                                 :password_confirmation)
  end
end
