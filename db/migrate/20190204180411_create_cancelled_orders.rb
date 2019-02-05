class CreateCancelledOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :cancelled_orders do |t|
      t.text :internal_reason
      t.text :client_reason
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
