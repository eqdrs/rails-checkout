class AddOrderToOrderApproval < ActiveRecord::Migration[5.2]
  def change
    add_reference :order_approvals, :order, foreign_key: true
  end
end
