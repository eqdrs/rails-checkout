class Customer < ApplicationRecord
  has_many :orders
  validates :name, :email, :cpf, :address, :phone, presence: { message: "Este campo é obrigatório"}
end
