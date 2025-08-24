FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    description { Faker::Lorem.sentence }

    trait :with_parent do
      association :parent, factory: :category
    end

    trait :electronics do
      name { "Electronics" }
      description { "Electronic devices and gadgets" }
    end

    trait :fashion do
      name { "Fashion" }
      description { "Clothing and accessories" }
    end
  end
end

