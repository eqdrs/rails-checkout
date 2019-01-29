class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :status
      t.references :client, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
