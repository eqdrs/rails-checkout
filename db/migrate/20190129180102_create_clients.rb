class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :adress
      t.string :cpf
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
