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
    @order = Order.new
    @products = all_products
  end

  def create
    @product = get_product(params[:order][:product_id])
    @product.save
    @order = order_build(params[:order][:cpf], @product.id)
    order_validation(@order)
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

  def order_build(cpf, product_id)
    customer = Customer.find_by(cpf: cpf)
    product = Product.find_by('id = ?', product_id)
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

  def format_products(products)
    array = []
    products.each { |r| array << Product.new(r) }
    array
  end

  def get_product(id)
    uri = URI('http://localhost:3000/api/v1/products'\
              "/#{id}")
    response = JSON.parse(Net::HTTP.get(uri))
    Product.new(response)
  end

  def all_products
    uri = URI('http://localhost:3000/api/v1/products')
    @products = JSON.parse(Net::HTTP.get(uri))
    format_products(@products)
  end
end
