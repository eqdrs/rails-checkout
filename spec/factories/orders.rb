FactoryBot.define do
  factory :order do
    status { 0 }
    customer
    product
  end
end
