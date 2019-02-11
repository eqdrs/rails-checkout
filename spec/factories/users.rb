FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { '12345678' }
    role { :admin }
    cpf { CPF.generate }
    status { :active }
    factory :vendor do
      role { :vendor }
    end
  end
end
