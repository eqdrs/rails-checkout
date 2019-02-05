class RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication

  def new
    @user = User.new
  end

  def create
    @user = User.new(email: params[:user][:email], password: params[:user][:cpf],
                     role: params[:user][:role], cpf: params[:user][:cpf])
    if @user.save
      UserMailer.registered_user(@user.id).deliver
      redirect_to root_path, notice: 'Usuário cadastrado com sucesso!'
    else
      redirect_to register_path, notice: 'Você deve informar todos os campos obrigatórios'
    end
  end
end