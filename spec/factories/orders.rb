FactoryBot.define do
  factory :order do
    status { 0 }
    customer
    product
    user
  end
end
