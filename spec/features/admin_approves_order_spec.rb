require 'rails_helper'

feature 'Admin approves order' do
  scenario 'successfully' do
    user = create(:user, role: :admin)
    customer = create(:customer)
    product = create(:product)
    order = Order.create!(status: :open, customer: customer,
                          product: product, user: user)

    login_as user
    visit root_path
    click_on 'Detalhes'
    click_on 'Aprovar pedido'

    expect(page).to have_content('Pedido aprovado com sucesso!')
    expect(page).to have_content(order.customer.email)
    expect(page).to have_content(order.product.name)
    expect(page).to have_content('Aprovado')
    expect(page).not_to have_link('Aprovar pedido')
  end

  scenario 'and an already cancelled order can not be approved again' do
    user = create(:user, role: :admin)
    customer = create(:customer)
    product = create(:product)
    Order.create!(status: :cancelled, customer: customer,
                  product: product, user: user)

    login_as user
    visit root_path
    click_on 'Detalhes'

    expect(page).not_to have_link('Aprovar pedido')
  end

  scenario 'and an already approved order can not be approved again' do
    user = create(:user, role: :admin)
    customer = create(:customer)
    product = create(:product)
    Order.create!(status: :approved, customer: customer,
                  product: product, user: user)
    login_as user
    visit root_path
    click_on 'Detalhes'

    expect(page).not_to have_content('Aprovar pedido')
  end

  scenario 'and an order can not be approved again - forced' do
    user = create(:user, role: :admin)
    customer = create(:customer)
    product = create(:product)
    login_as user
    order = Order.create!(status: :approved, customer: customer,
                          product: product, user: user)

    page.driver.submit :post, '/orders/1/approve', {}

    expect(current_path).to eq order_path(order)
    expect(page).to have_content('Não é possível aprovar este pedido')
  end

  scenario 'and vendor can not approve an order' do
    user = create(:vendor)
    customer = create(:customer)
    product = create(:product)
    login_as user

    order = Order.create!(customer: customer, product: product, user: user)

    visit order_path(order)
    expect(page).to_not have_content 'Aprovar pedido'
  end

  scenario 'and vendor can not approve an order - forced' do
    user = create(:vendor)
    customer = create(:customer)
    product = create(:product)
    login_as user

    order = Order.create!(customer: customer, product: product, user: user,
                          status: 0)

    page.driver.submit :post, '/orders/1/approve', {}

    expect(current_path).to eq order_path(order)
    expect(page).to have_content('Não é possível aprovar este pedido')
  end
end
