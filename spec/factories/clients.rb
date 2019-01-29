FactoryBot.define do
  factory :client do
    name { FFaker::Name.name }
    adress { FFaker::AddressBR.full_address }
    cpf { "00000000000" }
    email { FFaker::Internet.email }
    phone { "5666-6666" }
  end
end
