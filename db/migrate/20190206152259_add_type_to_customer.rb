class AddTypeToCustomer < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :type, :string
  end
end
