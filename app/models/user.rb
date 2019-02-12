class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :orders, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum role: %i[admin vendor]
  enum status: { active: 0, inactive: 10 }

  def admin?
    role == 'admin'
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active? ? super : I18n.t('users.messages.inactive_user', email: email)
  end
end
