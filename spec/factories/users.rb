FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { '12345678' }
    role { :admin }
    factory :vendor do
      role { :vendor }
    end
  end
end
