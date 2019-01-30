class Client < ApplicationRecord
  validates :cpf, length: { is: 11, message: 'CPF inválido.' }
end
