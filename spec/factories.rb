FactoryGirl.define do
  factory :participant do
    sequence(:name) { |n| "My friend Bely the #{ActiveSupport::Inflector.ordinalize(n)}" }
  end
end
