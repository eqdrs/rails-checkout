class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show cancel_form cancel]
  before_action :verify_user, only: %i[approve]

  def index
    @orders = if current_user.admin?
                Order.all
              else
                Order.where(user: current_user)
              end
  end

  def new
    @customer = Customer.find(params[:customer_id])
    @order = Order.new
  end

  def create
    @order = order_build(params[:order][:product_id])
    if @order.save
      CustomerMailer.order_summary(@order.id).deliver
      redirect_to @order
    else
      render :new
    end
  end

  def show; end

  def cancel_form; end

  def cancel
    if @order.cancel_order(internal: params[:internal_reason],
                           client: params[:client_reason])
      redirect_to @order, notice: t('.cancel_message')
    else
      render :cancel_form
    end
  end

  def approve
    @order = Order.find(params[:id])
    @order.create_order_approval(user: current_user)
    @order.approved!
    redirect_to @order, notice: 'Pedido aprovado com sucesso!'
  end

  private

  def verify_user
    current_user.admin?
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def order_build(product_id)
    customer = Customer.find(params[:customer_id])
    product = Product.find(product_id)
    current_user.orders.new(customer: customer, product: product,
                            status: 0)
  end
end
