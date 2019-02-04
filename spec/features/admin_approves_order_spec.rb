require 'rails_helper'

feature 'Admin approves order' do
  scenario 'successfully' do
    user = create(:user)
    customer = create(:customer)
    product = create(:product)
    order = Order.create!(status: :open, customer: customer, product: product, 
                          user: user)

    login_as user
    visit root_path
    click_on 'Visualizar Pedidos'
    click_on 'Detalhes'
    click_on 'Aprovar pedido'

    expect(page).to have_content(order.customer.email)
    expect(page).to have_content(order.product.name)
    expect(page).to have_content('Aprovado')
    expect(page).not_to have_link('Aprovar pedido')
  end
end
