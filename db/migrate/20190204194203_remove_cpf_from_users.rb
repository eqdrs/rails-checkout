class RemoveCpfFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :cpf, :string
  end
end
