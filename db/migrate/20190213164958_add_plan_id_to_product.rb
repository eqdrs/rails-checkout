class AddPlanIdToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :plan_id, :integer
  end
end
