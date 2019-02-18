class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
  belongs_to :user

  validates :name, :email, :address,
            :phone, presence: true

  def as_json(options: nil)
    super.merge("type": type)
  end
end
