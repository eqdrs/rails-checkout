require 'rails_helper'

feature 'Seller register order' do
  scenario 'Successfully (for individuals)' do
    user = create(:user)
    customer = create(:individual)
    product = create(:product)
    mail_spy = spy(CustomerMailer)
    stub_const('CustomerMailer', mail_spy)
    login_as user

    visit root_path
    click_on 'Pesquisar cliente'
    fill_in 'Por CPF', with: customer.cpf
    within('form#individual') do
      click_on 'Buscar'
    end
    click_on 'Cadastrar pedido'
    select product.name, from: 'Produto'
    click_on 'Cadastrar'

    expect(current_path).to eq order_path(1)
    expect(page).to have_content(product.name)
    expect(page).to have_content(product.price)
    expect(page).to have_content(customer.name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_content(user.email)
    expect(mail_spy).to have_received(:order_summary)
  end

  scenario 'Successfully (for company)' do
    user = create(:user)
    customer = create(:company)
    product = create(:product)
    mail_spy = spy(CustomerMailer)
    stub_const('CustomerMailer', mail_spy)
    login_as user

    visit root_path
    click_on 'Pesquisar cliente'
    fill_in 'Por CNPJ', with: customer.cnpj
    within('form#company') do
      click_on 'Buscar'
    end
    click_on 'Cadastrar pedido'
    select product.name, from: 'Produto'
    click_on 'Cadastrar'

    expect(current_path).to eq order_path(1)
    expect(page).to have_content(product.name)
    expect(page).to have_content(product.price)
    expect(page).to have_content(customer.company_name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_content(user.email)
    expect(mail_spy).to have_received(:order_summary)
  end
end
