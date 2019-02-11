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

    expect(current_path).to eq order_path(order)
    expect(page).to have_css('strong', text: 'Cancelado')
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

    expect(current_path).to eq order_path(order)
    expect(page).to have_css('strong', text: 'Cancelado')
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

  scenario 'admin see order internal reasons' do
    admin = create(:user)
    order = create(:order)
    create(:cancelled_order, order: order)
    login_as admin

    visit order_path(order)

    expect(page).to have_content(order.cancelled_order.internal_reason)
    expect(page).to have_content(order.cancelled_order.client_reason)
  end

  scenario 'and must give the client reason' do
    user = create(:user)
    order = create(:order, user: user)
    login_as user

    visit root_path
    click_on order.id
    click_on 'Cancelar'
    fill_in 'Motivo interno', with: 'O cliente cancelou a compra'
    fill_in 'Motivo para o cliente', with: ''
    click_on 'Enviar'

    expect(page).to have_content(I18n.t('errors.messages.blank'))
  end

  scenario 'and the internal reason is optional' do
    user = create(:user)
    order = create(:order, user: user)
    login_as user

    visit root_path
    click_on order.id
    click_on 'Cancelar'
    fill_in 'Motivo interno (opcional)', with: ''
    fill_in 'Motivo para o cliente', with: 'Você cancelou o pedido'
    click_on 'Enviar'

    expect(current_path).to eq order_path(order)
    expect(page).to have_css('strong', text: 'Cancelado')
    expect(page).to have_css('div', text: 'Pedido cancelado com sucesso')
  end

  scenario 'and cant cancel cancelled orders' do
    user = create(:vendor)
    order = create(:order)
    order.cancel_order(internal: 'Motivo interno',
                       client: 'Motivo para o cliente')
    login_as user

    visit order_path(order)

    expect(page).not_to have_link('Cancelar pedido')
  end

  scenario 'and cant cancel cancelled orders - force' do
    user = create(:vendor)
    order = create(:order)
    order.cancel_order(internal: 'Motivo interno',
                       client: 'Motivo para o cliente')

    login_as user
    page.driver.submit :post, '/orders/1/cancel',
                       internal: 'Motivo interno',
                       client: 'Motivo para o cliente'

    expect(current_path).to eq order_path(order)
    expect(page).to have_content 'Este pedido não pode ser cancelado'
  end
end
