class CustomerMailer < ApplicationMailer
  def order_summary(order_id) 
    @order = Order.find(order_id)
    mail(to: @order.client.email, subject: 'Resumo do pedido')
  end
end