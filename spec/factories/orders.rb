FactoryBot.define do
  factory :order do
    status { 1 }
    client { nil }
    product { nil }
  end
end
