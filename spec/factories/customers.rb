FactoryBot.define do
  factory :customer do
    name { FFaker::NameBR.name }
    address { FFaker::AddressUS.street_name }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.phone_number }
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
