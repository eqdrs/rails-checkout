class Api::V1::CustomersController < Api::V1::ApplicationController
  def orders
    if customer?(params[:id])
      render json: Order.where(user: params[:id])
    else
      render status: :precondition_failed,
             json: { message: 'non-existent customer' }
    end
  end

  private

  def customer?(id)
    @customer = Customer.find_by id: id
    !@customer.nil?
  end
end
