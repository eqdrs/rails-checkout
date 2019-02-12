class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
  belongs_to :user

  validates :name, :email, :address,
            :phone, presence: true
end
