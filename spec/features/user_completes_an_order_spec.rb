require 'rails_helper'

feature 'User completes an order' do
  scenario 'successfully' do
    vendor = create(:vendor)
    order = create(:order, user: vendor)
    login_as vendor

    http = double('For - Net::HTTP')
    response = double('For - Net::HTTPResponse')
    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:get)
      .with(any_args).and_return(response)
    allow(response).to receive(:body).and_return('[{"period":"Mensal",
      "value":"25"},{"period":"Semestral","value":"50"}]')

    visit finish_order_path(order)
    select 'Mensal', from: 'period'

    expect(current_path).to order_path(order)
    expect(page).to have_content('R$ 25,00')
  end
end