require 'rails_helper'

feature 'Seller register order' do
  scenario 'Successfully (for individuals)' do
    skip
    user = create(:user)
    customer = create(:individual)
    product = create(:product, price: 50.0)
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
    choose product.name
    click_on 'Cadastrar Pedido'

    expect(current_path).to eq order_path(1)
    expect(page).to have_content(product.name)
    expect(page).to have_content('R$ 50,0')
    expect(page).to have_content(customer.name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_content(user.email)
    expect(mail_spy).to have_received(:order_summary)
  end

  scenario 'Successfully (for company)' do
    skip
    user = create(:user)
    customer = create(:company)
    product = create(:product, price: 25.0)
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
    choose product.name
    click_on 'Cadastrar Pedido'

    expect(current_path).to eq order_path(1)
    expect(page).to have_content(product.name)
    expect(page).to have_content('R$ 25,00')
    expect(page).to have_content(customer.company_name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_content(user.email)
    expect(mail_spy).to have_received(:order_summary)
  end

  scenario 'User select product and see all plans available' do
    stub_request(:get, 'http://localhost:3000/api/v1/products/plans')
      .to_return(body: File.read('spec/support/all_plans.json').to_s,
                 status: 200)

    user = create(:user)
    customer = create(:individual)
    product = create(:product)
    login_as user

    visit new_customer_order_path(customer)
    choose product.name
    click_on 'Avançar'

    expect(page).to have_content('1')
    expect(page).to have_content('Básico')
    expect(page).to have_content('Plano básico do produto')
    expect(page).to have_content('2')
    expect(page).to have_content('Avançado')
    expect(page).to have_content('Plano avançado do produto')
  end
end
