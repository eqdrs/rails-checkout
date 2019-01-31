FactoryBot.define do
  factory :order do
    status { 0 }
    client
    product
    user
  end
end
