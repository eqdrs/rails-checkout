FactoryBot.define do
  factory :cancelled_order do
    internal_reason { FFaker::Lorem.paragraph }
    client_reason { FFaker::Lorem.paragraph }
    order
  end
end
