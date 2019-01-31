class AddCustomersRefToOrder < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :customer, foreign_key: true
    drop_table :clients
  end
end
