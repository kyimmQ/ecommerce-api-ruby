FactoryBot.define do
  factory :permission do
    name { Faker::Lorem.word }

    trait :purchase_items do
      name { "purchase_items" }
    end

    trait :manage_store do
      name { "manage_store" }
    end

    trait :manage_system do
      name { "manage_system" }
    end
  end
end

