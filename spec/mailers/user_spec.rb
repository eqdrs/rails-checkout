require 'rails_helper'

RSpec.describe UserMailer do
  describe 'valid' do
    it 'should send email to new registered user' do
      user = create(:user)

      mail = UserMailer.registered_user(user.id)

      expect(mail.to).to eq [user.email]
      expect(mail.subject).to eq 'Sua conta no Vendas Locaweb foi criada com '\
                                 'sucesso'
      expect(mail.body).to include "Olá, #{user.email}! Sua conta no Vendas "\
                                   'Locaweb foi criada com sucesso!'
      expect(mail.body).to include "Username: #{user.email}"
      expect(mail.body).to include "Senha: #{user.cpf}"
    end
  end
end
