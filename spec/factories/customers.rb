FactoryBot.define do
  factory :customer do
    address { FFaker::AddressUS.street_name }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.phone_number }
    factory :individual, class: 'Individual' do
      name { FFaker::Name.name }
      cpf { FFaker::IdentificationBR.cpf }
      type { 'Individual' }
    end
    factory :company, class: 'Company' do
      company_name { FFaker::Lorem.word }
      cnpj { FFaker::IdentificationBR.cnpj }
      contact { FFaker::Lorem.word }
      type { 'Company' }
    end
  end
end
