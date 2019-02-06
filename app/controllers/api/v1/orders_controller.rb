class Api::V1::OrdersController < Api::V1::ApplicationController
  def index
    render json: Order.all
  end

  private

  def error?
    if @order.errors.any?
      render status: :precondition_failed,
             json: { message: @order.errors.full_messages }
    else
      render json: { message: '' }
    end
  end
end
