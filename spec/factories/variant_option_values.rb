FactoryBot.define do
  factory :variant_option_value do
    association :product_variant
    association :product_option_value
  end
end

