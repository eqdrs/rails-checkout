class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    customer = Customer.find_by(cpf: params[:order][:cpf])
    product = Product.find(params[:order][:product_id])
    @order = Order.new(customer: customer, product: product, status: 0)
    if @order.save
      CustomerMailer.order_summary(@order.id).deliver
      redirect_to @order
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end
end
