FactoryBot.define do
  factory :role do
    name { Faker::Job.title.downcase.gsub(' ', '_') }

    trait :buyer do
      name { "buyer" }
    end

    trait :owner do
      name { "owner" }
    end

    trait :admin do
      name { "admin" }
    end
  end
end

