class AddSentToClientAppFieldToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :sent_to_client_app, :integer, default: 0
  end
end
