require 'rails_helper'

feature 'User cancels order' do
  scenario 'successfully' do
    user = create(:user)
    order = create(:order, user: user)
    login_as user
    mailer_spy = spy(CustomerMailer)
    stub_const('CustomerMailer', mailer_spy)

    visit root_path
    click_on order.id
    click_on 'Cancelar'
    fill_in 'Motivo interno', with: 'O cliente cancelou a compra'
    fill_in 'Motivo para o cliente', with: 'Você cancelou o seu pedido'
    click_on 'Enviar'

    expect(current_path).to eq root_path
    expect(page).to have_css('td', text: 'Cancelado')
    expect(page).to have_css('div', text: 'Pedido cancelado com sucesso')
    expect(mailer_spy).to have_received(:cancelled_order)
  end

  scenario 'and cant cancel order from other user' do
    user = create(:vendor)
    other_user = create(:vendor)
    order = create(:order, user: other_user)
    login_as user

    visit root_path

    expect(page).not_to have_link(order.id)
  end

  scenario 'admin can cancel all orders' do
    user = create(:user)
    other_user = create(:vendor)
    order = create(:order, user: other_user)
    login_as user

    visit root_path
    click_on order.id
    click_on 'Cancelar'
    fill_in 'Motivo interno', with: 'O cliente cancelou a compra'
    fill_in 'Motivo para o cliente', with: 'Você cancelou o seu pedido'
    click_on 'Enviar'

    expect(current_path).to eq root_path
    expect(page).to have_css('td', text: 'Cancelado')
    expect(page).to have_css('div', text: 'Pedido cancelado com sucesso')
  end

  scenario 'vendor see order internal reasons' do
    user = create(:vendor)
    order = create(:order)
    create(:cancelled_order, order: order)
    login_as user

    visit order_path(order)

    expect(page).to have_content(order.cancelled_order.internal_reason)
    expect(page).to have_content(order.cancelled_order.client_reason)
  end

  scenario 'vendor see order internal reasons' do
    admin = create(:user)
    order = create(:order)
    create(:cancelled_order, order: order)
    login_as admin

    visit order_path(order)

    expect(page).to have_content(order.cancelled_order.internal_reason)
    expect(page).to have_content(order.cancelled_order.client_reason)
  end
end
