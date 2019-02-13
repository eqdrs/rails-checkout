class AddProductIdFieldToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :product_id, :integer
  end
end
