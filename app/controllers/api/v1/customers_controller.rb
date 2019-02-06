class Api::V1::CustomersController < Api::V1::ApplicationController
  def orders
    render json: Order.where(user: params[:id])
  end
end
