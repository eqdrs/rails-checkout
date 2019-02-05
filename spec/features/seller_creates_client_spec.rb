require 'rails_helper'

feature 'Seller creates customer' do
  scenario 'successfully' do
    user = create(:user)

    login_as user
    visit new_customer_path
    fill_in 'Nome', with: 'Kamyla Costa de Almeida'
    fill_in 'Endereço', with: 'Rua das palmas n 23 - Jundiá - MG'
    fill_in 'CPF', with: '148.804.177-69'
    fill_in 'E-mail', with: 'teste@teste.com'
    fill_in 'Telefone', with: '(15)2435-1324'
    click_on 'Cadastrar'

    expect(current_path).to eq customer_path(1)
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
    visit new_customer_path
    fill_in 'Nome', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'CPF', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Telefone', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content('Name Este campo é obrigatório')
    expect(page).to have_content('Address Este campo é obrigatório')
    expect(page).to have_content('Cpf Este campo é obrigatório')
    expect(page).to have_content('Email Este campo é obrigatório')
    expect(page).to have_content('Phone Este campo é obrigatório')
  end

  scenario 'and must be loged in' do
    user = create(:user)

    visit root_path
    click_on 'Cadastrar Cliente'

    expect(current_path).to_not eq new_customer_path
    expect(page).to_not have_css('h1', text: 'Cadastrar Cliente')
    expect(page).to have_content('Log in')
  end 
end
