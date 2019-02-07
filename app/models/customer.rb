class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
  validates :email, :address,
            :phone, presence: true
end
