class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :orders
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i[admin vendor]

  def admin?
    role == :admin
  end
end
