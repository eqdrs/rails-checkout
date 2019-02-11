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
    click_on 'Cadastrar Pedido'
    fill_in 'CPF', with: customer.cpf
    choose 'Email Marketing'
    click_on 'Cadastrar'

    expect(page).to have_content('Email Marketing')
    expect(page).to have_content(customer.name)
    expect(page).to have_content('Em Aberto')
    expect(mail_spy).to have_received(:order_summary)
  end

  scenario 'and must fill in all fields' do
    stub_request(:get, 'http://localhost:3000/api/v1/products')
      .to_return(body: File.read('spec/support/all_products.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products/1')
      .to_return(body: File.read('spec/support/show_product.json').to_s,
                 status: 200)

    user = create(:user)
    login_as user

    visit new_order_path
    fill_in 'CPF', with: ''
    choose 'Email Marketing'
    click_on 'Cadastrar'

    expect(page).to have_content(I18n.t('errors.messages.required'))
  end

  scenario 'and customer must exist' do
    stub_request(:get, 'http://localhost:3000/api/v1/products')
      .to_return(body: File.read('spec/support/all_products.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products/1')
      .to_return(body: File.read('spec/support/show_product.json').to_s,
                 status: 200)

    user = create(:user)
    login_as user

    visit new_order_path
    fill_in 'CPF', with: '12345678910'
    choose 'Email Marketing'
    click_on 'Cadastrar'

    expect(page).to have_content(I18n.t('errors.messages.required'))
  end
end
