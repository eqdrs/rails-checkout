require 'rails_helper'

feature 'User change password in first login' do
  scenario 'successfully' do
    user = create(:user, password: '12345678')

    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(current_path).to eq edit_passwords_path
  end

  scenario 'and must be a valid password' do
    user = create(:user, password: '12345678')

    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'
    fill_in 'Senha atual', with: '12345678'
    fill_in 'Senha', with: '123'
    fill_in 'Confirmar senha', with: '123'
    click_on 'Alterar senha'

    expect(page).to have_content('Atualização de senha falhou')
  end

  scenario 'and can login with new password' do
    user = create(:user, email: 'vendas@vendas.com', password: '12345678')

    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'
    fill_in 'Senha atual', with: '12345678'
    fill_in 'Senha', with: '87654321'
    fill_in 'Confirmar senha', with: '87654321'
    click_on 'Alterar senha'
    click_on 'Sair'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: '87654321'
    click_on 'Entrar'

    expect(current_path).to eq root_path
    expect(page).to have_content "Olá, #{user.email}"
  end
end
