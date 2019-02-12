require 'rails_helper'

describe CustomerMailer do
  describe 'valid' do
    it 'should send email to customer' do
      order = create(:order)

      mail = CustomerMailer.order_summary(order.customer.id)

      expect(mail.to).to include(order.customer.email)
      expect(mail.subject).to eq 'Resumo do pedido'
      expect(mail.body).to include(CGI.escape_html(order.customer.name))
      expect(mail.body).to include(order.product.name)
      expect(mail.body).to include(order.product.price)
    end

    it '#approved_order' do
      customer = create(:customer)
      order = create(:order, status: 10, customer: customer)

      mail = CustomerMailer.approved_order(order.id)

      expect(mail.to).to eq [customer.email]
      expect(mail.subject).to eq 'Seu pedido foi aprovado'
      expect(mail.body).to include "Seu pedido #{order.product.name} "\
                                   'foi aprovado'
    end

    it '#cancelled_order' do
      customer = create(:customer)
      order = create(:order, customer: customer)
      create(:cancelled_order, order: order)

      mail = CustomerMailer.cancelled_order(order.id)

      expect(mail.to).to eq [customer.email]
      expect(mail.subject).to eq 'Seu pedido foi cancelado'
      expect(mail.body).to include "Seu pedido #{order.product.name} "\
                                   'foi cancelado'
      expect(mail.body).to include order.cancelled_order.client_reason
    end
  end
end
