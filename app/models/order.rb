class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :product
  belongs_to :user

  enum status: { open: 0, approved: 10, cancelled: 20 }
end
