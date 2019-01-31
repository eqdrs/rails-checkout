class RemoveClientFromOrder < ActiveRecord::Migration[5.2]
  def change
    remove_reference :orders, :client, foreign_key: true
  end
end
