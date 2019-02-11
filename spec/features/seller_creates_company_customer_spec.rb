require 'rails_helper'

feature 'Seller creates company customer' do
  scenario 'successfully' do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Pessoa jurídica'
    fill_in 'Nome', with: 'Facebook'
    fill_in 'Endereço', with: 'Rua das palmas n 23 - Jundiá - MG'
    fill_in 'CNPJ', with: '17.298.092/0001-30'
    fill_in 'E-mail', with: 'facebook@teste.com'
    fill_in 'Telefone', with: '(15)2435-1324'
    fill_in 'Contato', with: 'Mark Zuck'
    click_on 'Cadastrar'

    expect(current_path).to eq company_path(1)
    expect(page).to have_content('Facebook')
    expect(page).to have_content('Rua das palmas n 23 - Jundiá - MG')
    expect(page).to have_content('17.298.092/0001-30')
    expect(page).to have_content('facebook@teste.com')
    expect(page).to have_content('(15)2435-1324')
    expect(page).to have_content('Mark Zuck')
    expect(page).to have_link('Cadastrar pedido')
  end

  scenario 'and must fill all fields' do
    user = create(:user)

    login_as user
    visit new_company_path
    fill_in 'Nome', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Telefone', with: ''
    fill_in 'Contato', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content("Nome #{I18n
                                                 .t('errors.messages.blank')}")
    expect(page).to have_content("Endereço #{I18n.t('errors.messages.blank')}")
    expect(page).to have_content("CNPJ #{I18n.t('errors.messages.blank')}")
    expect(page).to have_content("Telefone #{I18n.t('errors.messages.blank')}")
    expect(page).to have_content("E-mail #{I18n.t('errors.messages.blank')}")
    expect(page).to have_content("Contato #{I18n.t('errors.messages.blank')}")
  end

  scenario 'and must be loged in' do
    skip

    visit root_path
    click_on 'Cadastrar Cliente'

    expect(current_path).to_not eq new_customer_path
    expect(page).to_not have_css('h1', text: 'Cadastrar Cliente')
    expect(page).to have_content('Log in')
  end
end
