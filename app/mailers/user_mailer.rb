class UserMailer < ApplicationMailer
  def registered_user(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Sua conta no Vendas Locaweb foi criada '\
                                   'com sucesso')
  end
end
