class Order < ApplicationRecord
  belongs_to :client
  belongs_to :product

  enum status: { open: 0, approved: 10, cancelled: 20 }
end
