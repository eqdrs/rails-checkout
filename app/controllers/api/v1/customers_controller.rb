class Api::V1::CustomersController < Api::V1::ApplicationController
  def get_orders
    render json: Order.where(user: params[:id])
  end
end