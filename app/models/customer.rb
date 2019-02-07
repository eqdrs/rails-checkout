class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
  belongs_to :user
  validates :email, :address,
            :phone, presence: true
end
