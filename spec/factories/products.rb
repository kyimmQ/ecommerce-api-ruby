FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    image_url { Faker::Internet.url(host: 'images.unsplash.com', path: '/500x500') }
    association :category
    association :owner, factory: [ :user, :owner ]

    trait :with_variants do
      after(:create) do |product|
        create_list(:product_variant, 2, product: product)
      end
    end

    trait :electronics do
      association :category, :electronics
      name { "#{Faker::Company.name} #{[ 'Smartphone', 'Laptop', 'Tablet' ].sample}" }
    end

    trait :fashion do
      association :category, :fashion
      name { "#{[ 'Men\'s', 'Women\'s' ].sample} #{Faker::Commerce.product_name}" }
    end
  end
end

