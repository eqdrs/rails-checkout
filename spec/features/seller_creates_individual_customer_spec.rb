require 'rails_helper'

feature 'Seller creates individual customer' do
  scenario 'successfully' do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Pessoa física'
    fill_in 'Nome', with: 'Kamyla Costa de Almeida'
    fill_in 'Endereço', with: 'Rua das palmas n 23 - Jundiá - MG'
    fill_in 'CPF', with: '148.804.177-69'
    fill_in 'E-mail', with: 'teste@teste.com'
    fill_in 'Telefone', with: '(15)2435-1324'
    click_on 'Cadastrar'

    expect(current_path).to eq individual_path(1)
    expect(page).to have_content('Kamyla Costa de Almeida')
    expect(page).to have_content('Rua das palmas n 23 - Jundiá - MG')
    expect(page).to have_content('148.804.177-69')
    expect(page).to have_content('teste@teste.com')
    expect(page).to have_content('(15)2435-1324')
    expect(page).to have_link('Cadastrar pedido')
  end

  scenario 'and must fill all fields' do
    user = create(:user)

    login_as user
    visit new_individual_path
    fill_in 'Nome', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'CPF', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Telefone', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content("Nome #{I18n.t('errors.messages.blank')}")
    expect(page).to have_content("Endereço #{I18n.t('errors.messages.blank')}")
    expect(page).to have_content("CPF #{I18n.t('errors.messages.blank')}")
    expect(page).to have_content("Telefone #{I18n.t('errors.messages.blank')}")
    expect(page).to have_content("E-mail #{I18n.t('errors.messages.blank')}")
  end

  scenario 'and must be logged in' do
    skip

    visit root_path

    expect(current_path).to eq new_user_session_path
    expect(page).to_not have_link 'Cadastrar cliente'
  end
end
