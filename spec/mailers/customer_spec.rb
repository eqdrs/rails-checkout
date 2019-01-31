require 'rails_helper'

describe CustomerMailer do
  describe 'valid' do
    it 'should send email to customer' do
      order = create(:order)

      mail = CustomerMailer.order_summary(order.customer.id)

      expect(mail.to).to include(order.customer.email)
      expect(mail.subject).to eq 'Resumo do pedido'
      expect(mail.body).to include(order.customer.name)
      expect(mail.body).to include(order.product.name)
      expect(mail.body).to include(order.product.price)
    end
  end
end