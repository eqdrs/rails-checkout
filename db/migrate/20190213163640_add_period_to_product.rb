class AddPeriodToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :period, :string
  end
end
