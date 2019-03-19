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

    post "/orders/#{Order.last.id}/send_approval"
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

    post "/orders/#{Order.last.id}/send_approval"
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.warning'))
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

    post "/orders/#{Order.last.id}/send_approval"
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.warning'))
  end

  it 'and it allows the admin to resend the order to Clients successfully' do
    http = double('Instance of Net::HTTP')
    http_response = double('Instance of Net::HTTPResponse')
    admin = create(:user)
    vendor = create(:vendor)
    login_as admin
    create(:order, user: vendor, status: :approved)

    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:post)
      .with(Rails.configuration.customer_app['send_order_endpoint'], any_args)
      .and_return(http_response)
    allow(http_response).to receive(:code).and_return(201)

    post "/orders/#{Order.last.id}/send_approval"
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.success'))
  end

  it 'and it allows the vendor to resend the order to Clients sucessfully' do
    http = double('Instance of Net::HTTP')
    http_response = double('Instance of Net::HTTPResponse')
    vendor = create(:vendor)
    login_as vendor
    create(:order, user: vendor, status: :approved)

    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:post)
      .with(Rails.configuration.customer_app['send_order_endpoint'], any_args)
      .and_return(http_response)
    allow(http_response).to receive(:code).and_return(201)

    post "/orders/#{Order.last.id}/send_approval"
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.success'))
  end

  it 'and it doesnt resend already sent orders' do
    admin = create(:user)
    login_as admin
    create(:order, status: :approved, sent_to_client_app: :sent)

    post "/orders/#{Order.last.id}/send_approval"
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.already_sent'))
  end

  it 'and only the vendor who created the order can resend it' do
    vendor = create(:vendor)
    other_vendor = create(:vendor)
    login_as vendor
    create(:order, user: other_vendor, status: :approved)

    post "/orders/#{Order.last.id}/send_approval"
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.approve.unauthorized'))
  end

  it 'and visitors cant resend orders' do
    create(:order, user: create(:vendor), status: :approved)

    post "/orders/#{Order.last.id}/send_approval"

    expect(response).to redirect_to new_user_session_path
  end

  it 'and cant resend orders that dont exist' do
    admin = create(:user)
    login_as admin

    post '/orders/1/send_approval'
    follow_redirect!

    expect(response.body).to include(I18n.t('orders.messages.no_order', id: 1))
  end
end
