class Api::V1::CustomersController < Api::V1::ApplicationController
  def orders
    render json: Order.where(customer: params[:id])
  end
end
