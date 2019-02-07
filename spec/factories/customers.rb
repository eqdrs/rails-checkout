FactoryBot.define do
  factory :customer do
    address { FFaker::AddressUS.street_name }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.phone_number }
    name { FFaker::Name.name }
    factory :individual, class: 'Individual' do
      cpf { FFaker::IdentificationBR.cpf }
      type { 'Individual' }
    end
    factory :company, class: 'Company' do
      cnpj { FFaker::IdentificationBR.cnpj }
      contact { FFaker::Lorem.word }
      type { 'Company' }
    end
  end
end
