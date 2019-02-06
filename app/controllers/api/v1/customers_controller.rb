class Api::V1::CustomersController < Api::V1::ApplicationController
  def orders
    unless customer?(params[:id])
      @orders = Order.where(user: params[:id])
      render json: @orders
    end
  end

  private

  def customer?(id)
    @customer = Customer.find_by id: id
    if @customer.nil?
      render status: :precondition_failed,
             json: { message: 'non-existent customer' }
    end
  end
end
