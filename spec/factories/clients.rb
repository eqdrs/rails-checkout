FactoryBot.define do
  factory :client do
    name { FFaker::Name.name }
    adress { 'MyString' }
    cpf { FFaker::IdentificationBR.cpf }
    email { 'MyString' }
    phone { 'MyString' }
  end
end
