class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @orders = Order.all
    else
      @orders = Order.where(user: current_user)
    end
  end

  def new
    @order = Order.new
  end

  def create
    customer = Client.find_by(cpf: params[:order][:cpf])
    product = Product.find(params[:order][:product_id])
    @order = current_user.orders.new(client: customer, product: product, status: 0)
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
