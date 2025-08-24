FactoryBot.define do
  factory :product_option do
    name { [ 'Color', 'Size', 'Material', 'Style' ].sample }

    trait :color do
      name { "Color" }
    end

    trait :size do
      name { "Size" }
    end

    trait :storage do
      name { "Storage" }
    end
  end
end

