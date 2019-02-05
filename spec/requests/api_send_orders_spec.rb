require 'rails_helper'

describe 'Api send orders' do
  it 'successfully' do
    order = create(:order, status: :approved)
    create(:order, status: :approved)
    create(:order, status: :open)
    create(:order, status: :cancelled)

    get '/api/v1/orders'

    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(order.id.to_s)
    expect(response.body).to include(order.product_id.to_s)
    expect(response.body).to include(order.customer_id.to_s)
    expect(response.body).to_not include('open')
    expect(response.body).to_not include('cancelled')
  end
end
