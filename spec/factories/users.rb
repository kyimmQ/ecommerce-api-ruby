FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.full_address }

    trait :buyer do
      after(:create) do |user|
        buyer_role = Role.find_or_create_by(name: "buyer")
        UserRole.create(user: user, role: buyer_role)
      end
    end

    trait :owner do
      after(:create) do |user|
        owner_role = Role.find_or_create_by(name: "owner")
        UserRole.create(user: user, role: owner_role)
      end
    end

    trait :admin do
      after(:create) do |user|
        admin_role = Role.find_or_create_by(name: "admin")
        UserRole.create(user: user, role: admin_role)
      end
    end
  end
end

