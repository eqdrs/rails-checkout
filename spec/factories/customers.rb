FactoryBot.define do
  factory :customer do
    name { FFaker::name }
    address { FFaker::AddressUS.street_name }
    cpf { FFaker::IdentificationBR.cpf }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.phone_number }
  end
end
