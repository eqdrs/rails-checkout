class AddNameAndPlanDescriptionToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :plan_name, :string
    add_column :products, :plan_description, :string
  end
end
