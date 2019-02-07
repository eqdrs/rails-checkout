require 'rails_helper'

describe 'Api post orders to clients' do
  it 'successfully' do
    allow(Net::HTTP).to receive(:post)
      .with(Rails.configuration.customer_app['approve_url'], any_args)
      .and_return(:ok)
  end

  it 'and it needs a token' do
    order = create(:order)
    data = { customer: order.customer, product: order.product }
    header = { 'Content-Type': 'application/json' }

    allow(Net::HTTP).to receive(:post)
      .with(Rails.configuration.customer_app['approve_url'], data, header)
      .and_return(403)
  end
end
