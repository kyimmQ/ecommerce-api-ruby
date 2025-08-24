FactoryBot.define do
  factory :product_option_value do
    value { Faker::Commerce.color }
    association :product_option

    trait :color_red do
      value { "Red" }
      association :product_option, :color
    end

    trait :size_large do
      value { "Large" }
      association :product_option, :size
    end

    trait :storage_256gb do
      value { "256GB" }
      association :product_option, :storage
    end
  end
end

