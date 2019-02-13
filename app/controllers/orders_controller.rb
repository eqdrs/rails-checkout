# rubocop: disable Metrics/ClassLength
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show cancel_form cancel approve plans
                                     choosed_plan]
  before_action :set_order_safe, only: %i[send_approval]
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
    begin
      @products = ProductsApi.all_products
    rescue StandardError
      redirect_to root_path, notice: 'Não foi possível conectar ao servidor'
    end
  end

  def create
    begin
      @product = ProductsApi.get_product(params[:order][:product_id])
    rescue StandardError
      redirect_to root_path, notice: 'Não foi possível conectar ao servidor'
    end
    @product.save
    @order = Order.create(user: current_user, customer_id: params[:customer_id],
                          product: @product)
    redirect_to plans_order_path(@order)
  end

  def plans
    @customer = @order.customer
    @product = @order.product
    begin
      @plans = ProductsApi.all_plans(@order.id)
    rescue StandardError
      redirect_to root_path, notice: 'Não foi possível conectar ao servidor'
    end
  end

  def choosed_plan
    @product = @order.product
    begin
      @plan = ProductsApi.get_plan(@order.product_id, params[:order][:plan_id])
    rescue StandardError
      redirect_to root_path, notice: 'Não foi possível conectar ao servidor'
    end
    @product.set_infos(@plan['id'], @plan['name'], @plan['description'])
    redirect_to @order
  end

  def show; end

  def cancel_form; end

  def cancel
    if @order.cancelled? || @order.approved?
      redirect_to @order, notice: 'Este pedido não pode ser cancelado'
    elsif @order.cancel_order(internal: params[:internal_reason],
                              client: params[:client_reason])
      redirect_to @order, notice: t('.cancel_message')
    else
      render :cancel_form
    end
  end

  def approve
    if @order.approve_order(user: current_user)
      return post_request_approve(order: @order)
    end

    redirect_to @order, alert: t('orders.approve.failure')
  end

  def send_approval
    if !@order.creator?(user: current_user) && !current_user.admin?
      return redirect_to orders_path, notice: t('orders.approve.unauthorized')
    end

    post_request_approve(order: @order)
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_order_safe
    @order = Order.find(params[:id])
  rescue StandardError
    flash[:notice] = t('orders.messages.no_order', id: params[:id])
    redirect_to orders_path
  end

  def order_build(product_id)
    customer = Customer.find(params[:customer_id])
    product = Product.find(product_id)
    current_user.orders.new(customer: customer, product: product,
                            status: 0)
  end

  def order_validation(order)
    if order.save
      CustomerMailer.order_summary(order.id).deliver
      redirect_to plans_order_path(id: @order)
    else
      @products = ProductsApi.all_products
      render :new
    end
  end

  def post_request_approve(order:)
    return already_sent(order: order) if order.sent?

    data = { customer: order.customer, product: order.product }
    response = post_to(
      endpoint: Rails.configuration.customer_app['send_order_endpoint'],
      data: data
    )

    post_request_redirection(response: response, order: order)
  end

  def post_request_redirection(response:, order:)
    if response.code.to_s.match?(/2\d\d/)
      order.sent!
      redirect_to order, notice: t('orders.approve.success')
    else
      redirect_to order, notice: t('orders.approve.warning')
    end
  end

  def already_sent(order:)
    redirect_to order, notice: t('orders.approve.already_sent')
  end
end
# rubocop: enable Metrics/ClassLength
