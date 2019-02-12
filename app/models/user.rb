class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :orders, dependent: :destroy
  has_many :customers, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum role: %i[admin vendor]

  def admin?
    role == 'admin'
  end

  def individuals
    admin? && Individual.all ||
      Individual.where(user: self)
  end

  def companies
    admin? && Company.all ||
      Company.where(user: self)
  end
end
