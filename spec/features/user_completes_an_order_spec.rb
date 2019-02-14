require 'rails_helper'

feature 'User completes an order' do
  scenario 'successfully' do
    vendor = create(:vendor)
    product = create(:product, product_id: 1, plan_id: 1)
    order = create(:order, user: vendor, product: product)
    login_as vendor

    stub_request(
      :get,
      "#{Rails.configuration.products_app['get_products']}/1/plans/1/prices"
    ).to_return(body: '[{"period":"Mensal","value":"25"},{"period":"Semestral"'\
                      ',"value":"50"}]', status: :ok)

    visit finish_order_path(order)
    select 'Mensal', from: 'period'
    click_on 'commit'

    expect(current_path).to eq order_path(order)
    expect(page).to have_content('R$ 25,00')
  end

  scenario 'fails when order has no plan id' do
    vendor = create(:vendor)
    order = create(:order, user: vendor)
    login_as vendor

    stub_request(
      :get,
      "#{Rails.configuration.products_app['get_products']}/1/plans/1/prices"
    ).to_return(body: '[{"period":"Mensal","value":"25"},{"period":"Semestral"'\
                      ',"value":"50"}]', status: :ok)

    visit finish_order_path(order)

    expect(page).to have_content(I18n.t('orders.messages.no_plan'))
    expect(current_path).to_not eq finish_order_path(order)
  end
end
