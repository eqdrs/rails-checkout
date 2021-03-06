require 'rails_helper'

feature 'Seller register order' do
  scenario 'User select product and see all plans available' do
    stub_request(:get, 'http://localhost:3000/api/v1/products/1')
      .to_return(body: File.read('spec/support/show_product.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products')
      .to_return(body: File.read('spec/support/all_products.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products/1/plans')
      .to_return(body: File.read('spec/support/all_plans.json').to_s,
                 status: 200)

    user = create(:user)
    customer = create(:individual)

    login_as user

    visit new_customer_order_path(customer)
    choose 'Email Marketing'
    click_on 'Avançar'

    expect(page).to have_content('Email Marketing')
    expect(page).to have_content(customer.name)
    within('div#plans') do
      expect(page).to have_content('Basico')
      expect(page).to have_content('Plano básico do produto')
      expect(page).to have_content('Avançado')
      expect(page).to have_content('Plano avançado do produto')
    end
  end

  scenario 'User select product, plan, period and see details of order' do
    stub_request(:get, 'http://localhost:3000/api/v1/products/1')
      .to_return(body: File.read('spec/support/show_product.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products')
      .to_return(body: File.read('spec/support/all_products.json').to_s,
                 status: 200)

    stub_request(:get, 'http://localhost:3000/api/v1/products/1/plans')
      .to_return(body: File.read('spec/support/all_plans.json').to_s,
                 status: 200)
    stub_request(:get, 'http://localhost:3000/api/v1/products/1/plans/1')
      .to_return(body: File.read('spec/support/show_plan.json').to_s,
                 status: 200)

    stub_request(
      :get,
      "#{Rails.configuration.products_app['get_products']}/1/plans/1/prices"
    ).to_return(body: File.read('spec/support/prices.json').to_s,
                status: 200)

    user = create(:user)
    customer = create(:individual)

    login_as user

    visit new_customer_order_path(customer)
    choose 'Email Marketing'
    click_on 'Avançar'
    choose 'Basico'
    click_on 'Avançar'
    select 'Semestral', from: 'period'
    click_on 'commit'

    expect(current_path).to eq order_path(1)
    expect(page).to have_content('Email Marketing')
    expect(page).to have_content(customer.company_name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_content(user.email)
    expect(page).to have_content('Basico')
    expect(page).to have_content('Plano Basico Basico mesmo')
    expect(page).to have_content('R$ 30,00')
  end

  scenario 'and is shown an error if the products API is offline' do
    stub_request(:get, Rails.configuration.products_app['get_products'])
      .to_return(body: File.read('spec/support/all_products.json'),
                 status: 200)
    stub_request(:get, "#{Rails.configuration.products_app['get_products']}/1")
      .to_raise(StandardError)

    user = create(:user)
    customer = create(:individual)

    login_as user

    visit new_customer_order_path(customer)
    choose 'Email Marketing'
    click_on 'Avançar'

    expect(current_path).to eq root_path
    expect(page).to have_content('Não foi possível conectar ao servidor')
  end

  scenario 'and is shown an error if doesnt get plans list' do
    stub_request(:get, Rails.configuration.products_app['get_products'])
      .to_return(body: File.read('spec/support/all_products.json'),
                 status: 200)
    stub_request(:get, "#{Rails.configuration.products_app['get_products']}/1")
      .to_return(body: File.read('spec/support/show_product.json'),
                 status: 200)
    stub_request(:get, "#{Rails.configuration.products_app['get_products']}/"\
                       '1/plans').to_raise(StandardError)

    user = create(:user)
    customer = create(:individual)

    login_as user
    visit new_customer_order_path(customer)
    choose 'Email Marketing'
    click_on 'Avançar'

    expect(current_path).to eq root_path
    expect(page).to have_content('Não foi possível conectar ao servidor')
  end

  scenario 'and is shown an error if cant select the chosen plan' do
    stub_request(:get, Rails.configuration.products_app['get_products'])
      .to_return(body: File.read('spec/support/all_products.json'),
                 status: 200)
    stub_request(:get, "#{Rails.configuration.products_app['get_products']}/1")
      .to_return(body: File.read('spec/support/show_product.json'),
                 status: 200)
    stub_request(:get, "#{Rails.configuration.products_app['get_products']}/"\
                 '1/plans')
      .to_return(body: File.read('spec/support/all_plans.json', status: 200))
    stub_request(:get, "#{Rails.configuration.products_app['get_products']}/"\
                 '1/plans/1').to_raise(StandardError)

    user = create(:user)
    customer = create(:individual)

    login_as user
    visit new_customer_order_path(customer)
    choose 'Email Marketing'
    click_on 'Avançar'
    choose 'Basico'
    click_on 'Avançar'

    expect(current_path).to eq root_path
    expect(page).to have_content('Não foi possível conectar ao servidor')
  end
end
