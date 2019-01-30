require 'rails_helper'

feature 'Admin register vendor' do
  scenario 'successfully' do
    visit root_path
    click_on 'Cadastrar usuário'
    fill_in 'Email', with: 'teste@vendas.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    select 'Vendedor', from: 'Função'
    click_on 'Cadastrar'

    expect(page).to have_content('Login efetuado com sucesso. '\
                                 'Se não foi autorizado, a confirmação '\
                                 'será enviada por e-mail.')
    expect(current_path).to eq root_path
    expect(page).to have_content 'Olá, teste@vendas.com'
  end

  scenario 'and must fill empty fields' do
    visit root_path
    click_on 'Cadastrar usuário'
    fill_in 'Email', with: ''
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirme sua senha', with: '12345678'
    select 'Vendedor', from: 'Função'
    click_on 'Cadastrar'

    expect(page).to have_content('O campo email não pode ficar em branco.')
  end
end
