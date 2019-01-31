require 'rails_helper'

feature 'Admin views orders and customers' do
  scenario 'successfully' do
    admin = create(:user, role: :admin)
    order = create(:order)
    other_order = create(:order)

    login_as(admin, scope: :user)
    visit root_path

    expect(page).to have_content order.customer.name
    expect(page).to have_content order.product.name
    expect(page).to have_content order.product.price
    expect(page).to have_content order.status

    expect(page).to have_content other_order.customer.name
    expect(page).to have_content other_order.product.name
    expect(page).to have_content other_order.product.price
    expect(page).to have_content other_order.status
  end

  scenario 'no orders available' do
    admin = create(:user, role: :admin)

    login_as(admin, scope: :user)
    visit root_path

    expect(page).to have_content 'Não há pedidos cadastrados.'
  end
end