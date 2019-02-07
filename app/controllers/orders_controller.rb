class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show cancel_form cancel approve]
  before_action :verify_user, only: %i[approve]

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
    if @order.approve_order(user: current_user)
      data = { customer: @order.customer, product: @order.product }
      post_to(url: Rails.configuration.customer_app['approve_url'], data: data)
      redirect_to @order, notice: t('orders.approve.success')
    else
      redirect_to @order, alert: t('orders.approve.failure')
    end
  end

  private

  def verify_user
    current_user.admin?
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def order_build(cpf, product_id)
    customer = Customer.find_by(cpf: cpf)
    product = Product.find(product_id)
    current_user.orders.new(customer: customer, product: product,
                            status: 0)
  end
end
