require 'rails_helper'

describe CustomerMailer do
  describe 'valid' do
    it 'should send email to customer' do
      order = create(:order)

      mail = CustomerMailer.order_summary(order.client.id)

      expect(mail.to).to include(order.client.email)
      expect(mail.subject).to eq 'Resumo do pedido'
    end
  end
end