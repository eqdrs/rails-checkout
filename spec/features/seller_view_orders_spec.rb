require 'rails_helper'

feature 'Seller view orders' do
  scenario 'Successfully' do
    user = create(:user)
    order = create(:order, user: user)
    login_as user

    visit root_path

    expect(page).to have_link(order.id)
    expect(page).to have_css('td', text: order.customer.email)
    expect(page).to have_css('td', text: I18n.t("orders.show.#{order.status}"))
  end

  scenario 'and show message if there are no orders' do
    user = create(:user)
    login_as user

    visit root_path

    expect(page).to have_css('p', text: I18n.t('orders.index.no_orders'))
  end

  scenario 'click on id and see all details' do
    user = create(:user)
    product = create(:product, price: 50.0)
    order = create(:order, user: user, product: product)
    login_as user

    visit root_path
    click_on order.id

    expect(current_path).to eq(order_path(order))
    expect(page).to have_content(order.product.name)
    expect(page).to have_content('R$ 50,00')
    expect(page).to have_content(order.customer.email)
    expect(page).to have_content('Em Aberto')
  end

  scenario 'admin see all orders' do
    user = create(:user, role: 0)
    order = create(:order)
    other_order = create(:order)
    login_as user

    visit root_path
    expect(page).to have_link(order.id)
    expect(page).to have_css('td', text: order.customer.email)
    expect(page).to have_css('td', text: I18n.t("orders.show.#{order.status}"))
    expect(page).to have_link(other_order.id)
    expect(page).to have_css('td', text: other_order.customer.email)
    expect(page).to have_css('td', text: I18n.t("orders.show.#{other_order
                                                               .status}"))
  end
end
