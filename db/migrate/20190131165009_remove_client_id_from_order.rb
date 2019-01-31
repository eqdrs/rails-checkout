class RemoveClientIdFromOrder < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :orders, :client_id
  end
end
