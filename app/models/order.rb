class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :product
  has_one :order_approval, dependent: :destroy
  belongs_to :user
  has_one :cancelled_order, dependent: :destroy

  validates :product, presence: true

  enum status: { open: 0, approved: 10, cancelled: 20 }

  def cancel_order(internal:, client:)
    @cancelled = CancelledOrder.new(internal_reason: internal,
                                    client_reason: client,
                                    order: self)
    return unless @cancelled.save

    CustomerMailer.cancelled_order(id).deliver
    cancelled!
  end

  def approved_order?
    order_approval
  end
end
