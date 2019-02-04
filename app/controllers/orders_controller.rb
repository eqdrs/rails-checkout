class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = if current_user.admin?
                Order.all
              else
                Order.where(user: current_user)
              end
  end

  def new
    @order = Order.new
  end

  def create
    @order = order_build(params[:order][:cpf], params[:order][:product_id])
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
  
  private

  def order_build(cpf, product_id)
    customer = Customer.find_by(cpf: cpf)
    product = Product.find(product_id)
    current_user.orders.new(customer: customer, product: product,
                            status: 0)
  end
end
