class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :product
  has_one :order_approval, dependent: :destroy
  belongs_to :user
  has_one :cancelled_order, dependent: :destroy

  enum status: { open: 0, approved: 10, cancelled: 20 }

  def cancel_order(internal, client)
    cancelled!
    CancelledOrder.create(internal_reason: internal, client_reason: client,
                          order: self)
    CustomerMailer.cancelled_order(id).deliver
  end
end
