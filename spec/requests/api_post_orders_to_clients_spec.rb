require 'rails_helper'

describe 'Api post orders to clients' do
  it 'successfully' do
    http = double('Instance of Net::HTTP')
    http_response = double('Instance of Net::HTTPResponse')
    admin = create(:user)
    login_as admin
    create(:order)

    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:post)
      .with(Rails.configuration.customer_app['send_order_endpoint'], any_args)
      .and_return(http_response)
    allow(http_response).to receive(:code).and_return(201)

    post '/orders/1/approve'
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.success'))
  end

  it 'and it shows an error if it wasnt able to post successfully' do
    http = double('Instance of Net::HTTP')
    http_response = double('Instance of Net::HTTPResponse')
    admin = create(:user)
    login_as admin
    create(:order)

    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:post)
      .with(Rails.configuration.customer_app['send_order_endpoint'], any_args)
      .and_return(http_response)
    allow(http_response).to receive(:code).and_return(500)

    post '/orders/1/approve'
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.warning'))
    expect(response.body).to include(I18n.t('orders.show.approval_resend'))
  end

  it 'and it shows an error if an exception was raised sending the request' do
    http = double('Instance of Net::HTTP')
    admin = create(:user)
    login_as admin
    create(:order)

    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:post)
      .with(Rails.configuration.customer_app['send_order_endpoint'], any_args)
      .and_raise('Unable to open TCP connection')

    post '/orders/1/approve'
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.warning'))
    expect(response.body).to include(I18n.t('orders.show.approval_resend'))
  end

  it 'and it allows the admin to resend the order to Clients successfully' do
    http = double('Instance of Net::HTTP')
    http_response = double('Instance of Net::HTTPResponse')
    admin = create(:user)
    login_as admin
    create(:order, status: :approved)

    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:post)
      .with(Rails.configuration.customer_app['send_order_endpoint'], any_args)
      .and_return(http_response)
    allow(http_response).to receive(:code).and_return(201)

    post '/orders/1/send_approval'
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.success'))
  end

  it 'and it doesnt resend already sent orders' do
    admin = create(:user)
    login_as admin
    create(:order, status: :approved, sent_to_client_app: :sent)

    post '/orders/1/send_approval'
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.already_sent'))
  end
end
