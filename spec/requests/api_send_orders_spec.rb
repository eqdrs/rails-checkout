require 'rails_helper'

describe 'Api send orders' do
  it 'successfully' do
    order = create(:order, status: :approved)
    order_one = create(:order, status: :approved)
    order_two = create(:order, status: :open)
    order_three = create(:order, status: :cancelled)

    get '/api/v1/orders'
    resp = JSON.parse response.body
    puts response.body

    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:ok)
    expect(resp[0]['id']).to eq order.id
    expect(resp[0]['product_id']).to eq order.product_id
    expect(resp[0]['customer_id']).to eq order.customer_id
    expect(resp[0]['status']).to eq order.status

    expect(resp[1]['id']).to eq order_one.id
    expect(resp[1]['product_id']).to eq order_one.product_id
    expect(resp[1]['customer_id']).to eq order_one.customer_id
    expect(resp[1]['status']).to eq order_one.status

    expect(resp[2]['id']).to eq order_two.id
    expect(resp[2]['product_id']).to eq order_two.product_id
    expect(resp[2]['customer_id']).to eq order_two.customer_id
    expect(resp[2]['status']).to eq order_two.status

    expect(resp[3]['id']).to eq order_three.id
    expect(resp[3]['product_id']).to eq order_three.product_id
    expect(resp[3]['customer_id']).to eq order_three.customer_id
    expect(resp[3]['status']).to eq order_three.status


  end

  it 'of specific customer_id' do
    customer = create(:customer)
    other_customer = create(:customer)
    order = create(:order, status: :approved, customer: customer)
    create(:order, status: :approved, customer: other_customer)

    get "/api/v1/customers/#{customer.id}/orders"
    resp = JSON.parse response.body

    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:ok)
    expect(resp[0]['id']).to eq order.id
    expect(resp[0]['product_id']).to eq order.product_id
    expect(resp[0]['customer_id']).to eq order.customer_id
  end
end
