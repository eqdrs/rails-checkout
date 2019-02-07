class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
  validates :name, :email, :address,
            :phone, presence: true
end
