require 'rails_helper'

feature 'Seller register order' do
  scenario 'Successfully' do
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
    click_on 'Cadastrar Pedido'

    expect(current_path).to eq order_path(1)
    expect(page).to have_content('Email Marketing')
    expect(page).to have_content(customer.name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_content(user.email)
    expect(mail_spy).to have_received(:order_summary)
  end

  scenario 'Successfully (for company)' do
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
    click_on 'Cadastrar Pedido'

    expect(current_path).to eq order_path(1)
    expect(page).to have_content('Email Marketing')
    expect(page).to have_content(customer.company_name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_content(user.email)
    expect(mail_spy).to have_received(:order_summary)
  end
end
