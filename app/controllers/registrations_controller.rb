class RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication
  before_action :verify_user, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registered_user(@user.id).deliver
      redirect_to root_path, notice: 'Usuário cadastrado com sucesso!'
    else
      redirect_to register_path, notice: 'Você deve informar todos os campos '\
                                         'obrigatórios'
    end
  end

  private

  def verify_user
    current_user.vendor? &&
      (redirect_to root_path, notice: 'Você não tem permissão para realizar '\
                                      'esta ação')
  end

  def user_params
    params.require(:user).permit(:email, :role, :cpf)
          .merge(password: params[:user][:cpf])
  end
end
