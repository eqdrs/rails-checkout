class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

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

  def approve
    @order = Order.find(params[:id])
    @order.create_order_approval(user: current_user)
    @order.approved!
    render :show
  end
end
