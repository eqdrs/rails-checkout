require 'rails_helper'

feature 'user view order details' do
  scenario 'successfully' do
    customer = create(:customer)
    product = create(:product)
    order = Order.create!(status: :open, customer: customer, product: product)

    visit root_path
    click_on 'Visualizar Pedidos'
    click_on 'Detalhes'

    expect(page).to have_content(order.id)
    expect(page).to have_content(order.customer.email)
    expect(page).to have_content(order.product.name)
    expect(page).to have_content('Em Aberto')
    expect(page).to have_link('Aprovar pedido')
  end
end
