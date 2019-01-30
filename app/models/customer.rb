class Customer < ApplicationRecord
  validates :name, :email, :cpf, :address, :phone, presence: { message: "Este campo é obrigatório"}
end
