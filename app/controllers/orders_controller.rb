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
    begin
      @products = Services::Product.all_products
    rescue StandardError
      redirect_to root_path, notice: 'Não foi possível conectar ao servidor'
    end
  end

  def create
    begin
      @product = Services::Product.get_product(params[:order][:product_id])
    rescue StandardError
      redirect_to root_path, notice: 'Não foi possível conectar ao servidor'
    end
    @product.save
    @order = order_build(@product.id)
    order_validation(@order)
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
    @order = Order.find(params[:id])
    if @order.open?
      @order.create_order_approval(user: current_user)
      @order.approved!
      redirect_to @order, notice: 'Pedido aprovado com sucesso!'
    else
      redirect_to @order, notice: 'Não é possível aprovar este pedido'
    end
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

  def order_validation(order)
    if order.save
      CustomerMailer.order_summary(order.id).deliver
      redirect_to order
    else
      @products = all_products
      render :new
    end
  end
end
