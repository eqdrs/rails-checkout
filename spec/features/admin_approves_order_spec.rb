require 'rails_helper'

feature 'Admin approves order' do
  scenario 'successfully' do
    user = create(:user, role: :admin)
    customer = create(:customer)
    product = create(:product)
    order = Order.create!(status: :open, customer: customer, product: product,
                          user: user)
    http = double('For - Net::HTTP')
    http_response = double('For - Net::HTTPResponse')

    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:post)
      .with(Rails.configuration.customer_app['send_order_endpoint'], any_args)
      .and_return(http_response)
    allow(http_response).to receive(:code).and_return(201)

    login_as user
    visit root_path
    click_on 'Visualizar Pedidos'
    click_on 'Detalhes'
    click_on 'Aprovar pedido'

    expect(page).to have_content('Pedido aprovado com sucesso!')
    expect(page).to have_content(order.customer.email)
    expect(page).to have_content(order.product.name)
    expect(page).to have_content('Aprovado')
    expect(page).not_to have_link('Aprovar pedido')
  end

  scenario 'and cant approve an approved order' do
    user = create(:user, role: :admin)
    customer = create(:customer)
    product = create(:product)
    order = Order.create!(status: :open, customer: customer, product: product,
                          user: user)
    order.approve_order(user: user)

    login_as user
    visit root_path
    click_on 'Visualizar Pedidos'
    click_on 'Detalhes'

    expect(page).not_to have_link('Aprovar pedido')
  end
end
