class CreateOrderApprovals < ActiveRecord::Migration[5.2]
  def change
    create_table :order_approvals do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
