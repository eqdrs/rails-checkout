FactoryBot.define do
  factory :customer do
    name { FFaker::Name.name }
    address { FFaker::AddressUS.street_name }
    cpf { FFaker::IdentificationBR.cpf }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.phone_number }
  end
end
