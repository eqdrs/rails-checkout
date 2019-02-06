class AddFieldsToCustomer < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :company_name, :string
    add_column :customers, :cnpj, :string
    add_column :customers, :contact, :string
  end
end
