class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
  validates :name, :email, :cpf,
            :address, :phone, presence: { message: 'Este campo é obrigatório' }
end
