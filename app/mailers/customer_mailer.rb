class CustomerMailer < ApplicationMailer
  def order_summary(order_id)
    @order = Order.find(order_id)
    mail(to: @order.customer.email, subject: 'Resumo do pedido')
  end

  def approved_order(order_id)
    @order = Order.find(order_id)
    mail(to: @order.customer.email, subject: 'Seu pedido foi aprovado')
  end

  def cancelled_order(order_id)
    @order = Order.find(order_id)
    mail(to: @order.customer.email, subject: 'Seu pedido foi cancelado')
  end
end
