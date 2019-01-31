require 'rails_helper'

feature 'Admin approves order' do
  scenario 'successfully' do
    skip
    customer = create(:customer)
    product = create(:product)
    order = Order.create!(status: :pending, customer: customer,
                          product: product)

    visit order_index_path
    click_on 'Detalhes'

    expect(page).to have_content(order.id)
    expect(page).to have_content(order.customer.email)
    expect(page).to have_content(order.product.name)
    expect(page).to have_link('Aprovar pedido')
  end
end
