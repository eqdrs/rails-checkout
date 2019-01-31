FactoryBot.define do
  factory :product do
    name { FFaker::Name.name }
    price { 50.0 }
  end
end
