FactoryBot.define do
  factory :product_variant do
    sku { Faker::Code.asin }
    price { Faker::Commerce.price(range: 10.0..1000.0) }
    stock_quantity { Faker::Number.between(from: 0, to: 100) }
    association :product

    trait :in_stock do
      stock_quantity { Faker::Number.between(from: 10, to: 100) }
    end

    trait :out_of_stock do
      stock_quantity { 0 }
    end

    trait :expensive do
      price { Faker::Commerce.price(range: 500.0..2000.0) }
    end

    trait :cheap do
      price { Faker::Commerce.price(range: 10.0..50.0) }
    end
  end
end

