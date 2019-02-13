require 'rails_helper'

feature 'Seller register order' do
  scenario 'Successfully' do
    skip
    stub_request(:get, 'http://localhost:3000/api/v1/products/1')
      .to_return(body: File.read('spec/support/show_product.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products')
      .to_return(body: File.read('spec/support/all_products.json').to_s,
                 status: 200)

    user = create(:user)
    customer = create(:individual)
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
    choose 'Email Marketing'
    click_on 'Avançar'

    expect(current_path).to eq order_path(1)
    expect(page).to have_content('Email Marketing')
    expect(page).to have_content(customer.name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_content(user.email)
    expect(mail_spy).to have_received(:order_summary)
  end

  scenario 'Successfully (for company)' do
    skip
    stub_request(:get, 'http://localhost:3000/api/v1/products/1')
      .to_return(body: File.read('spec/support/show_product.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products')
      .to_return(body: File.read('spec/support/all_products.json').to_s,
                 status: 200)

    user = create(:user)
    customer = create(:company)
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
    choose 'Email Marketing'
    click_on 'Avançar'

    expect(current_path).to eq order_path(1)
    expect(page).to have_content('Email Marketing')
    expect(page).to have_content(customer.company_name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_content(user.email)
    expect(mail_spy).to have_received(:order_summary)
  end

  scenario 'User select product and see all plans available' do
    stub_request(:get, 'http://localhost:3000/api/v1/products/1')
      .to_return(body: File.read('spec/support/show_product.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products')
      .to_return(body: File.read('spec/support/all_products.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products/plans')
      .to_return(body: File.read('spec/support/all_plans.json').to_s,
                 status: 200)

    user = create(:user)
    customer = create(:individual)

    login_as user

    visit new_customer_order_path(customer)
    choose 'Email Marketing'
    click_on 'Avançar'

    expect(page).to have_content('1')
    expect(page).to have_content('Básico')
    expect(page).to have_content('Plano básico do produto')
    expect(page).to have_content('2')
    expect(page).to have_content('Avançado')
    expect(page).to have_content('Plano avançado do produto')
  end
end
