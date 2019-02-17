require 'rails_helper'

feature 'User resends order to clients' do
  scenario 'successfully' do
    vendor = create(:vendor)
    order = create(:order, user: vendor, status: :approved,
                           sent_to_client_app: :not_sent)
    create(:order_approval, order: order)
    login_as vendor

    req = double('For - Net::HTTP')
    allow(Net::HTTP).to receive(:new).and_return(req)
    allow(req).to receive(:post)
      .and_return(Net::HTTPResponse.new(1.0, 200, 'OK'))

    visit order_path(order)
    click_on I18n.t('orders.show.approval_resend')

    expect(page).to have_content(I18n.t('orders.approve.success'))
  end

  scenario 'and not sent orders show a message on orders#index' do
    vendor = create(:vendor)
    order = create(:order, user: vendor, status: :approved,
                           sent_to_client_app: :not_sent)
    create(:order_approval, order: order)
    login_as vendor

    visit orders_path

    expect(page).to have_css('td', text: 'Não enviado')
  end
end
