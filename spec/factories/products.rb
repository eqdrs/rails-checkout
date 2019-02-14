FactoryBot.define do
  factory :product do
    name { FFaker::Lorem.word }
    price { 50.0 }
  end
end
